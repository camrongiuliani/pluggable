import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'dart:isolate';
import 'package:redis/redis.dart';
import 'package:uuid/uuid.dart';
import 'package:synchronized/synchronized.dart';
import 'package:collection/collection.dart';
import 'package:pluggable/pluggable.dart';

import 'exceptions.dart';

class _RedisAdapter<T extends Object> {
  late Command command;
  late int dbIdx;
  final Type type;
  final String host;
  final int port;
  final String? password;
  final int lockReleaseTimeout;
  final int lockRetries;
  final int lockRetryInterval;
  final RedisConnection _connection;
  final String lockIdentity;
  final Duration? expiresIn;
  final DecodeFunc<T>? fromEncodable;

  bool _open = false;
  final _transLock = Lock();
  final _openLock = Lock();

  _RedisAdapter({
    required this.host,
    required this.port,
    this.password,
    this.fromEncodable,
    this.expiresIn,
    this.lockRetries = 10,
    this.lockRetryInterval = 1000,
    this.lockReleaseTimeout = 10000,
  })  : type = T,
        _connection = RedisConnection(),
        lockIdentity = Uuid().v4();

  List<dynamic> get expirationParams => switch (expiresIn == null) {
        true => [],
        false => ['PX', expiresIn!.inMilliseconds],
      };

  Future<void> close() async {
    if (!_open) {
      return;
    }

    return command.get_connection().close();
  }

  Future<bool> ping() async {
    if (!_open) {
      return false;
    }

    try {
      return _openLock.synchronized(() async {
        final r = await command.send_object(['PING']);
        return r == "PONG";
      });
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getAll([String? key]) async {
    if (!_open) {
      return {};
    }

    try {
      return _openLock.synchronized(() async {
        final keys = await command.send_object(['KEYS', '*']);

        if (keys is! List) {
          return {};
        }

        if (key != null) {
          keys.retainWhere((k) {
            return k == key;
          });
        }

        final results = <String, dynamic>{};

        for (final key in keys) {
          final value = await get(key);

          results[key] = switch (value) {
            String _ || int _ || bool _ || num _ || double _ => value,
            _ => () {
                return (value as dynamic)?.toJson();
              }(),
          };
        }

        return results;
      });
    } catch (e) {
      Pluggable.logger.e(
        e.toString(),
        err: e,
        stackTrace: StackTrace.current,
        tag: '$runtimeType',
      );
    }

    return {};
  }

  Future<void> open() async {
    if (_open) {
      return;
    }

    try {
      await _openLock.synchronized(() async {
        Socket socket = await Socket.connect(host, port);
        SecureSocket secureSocket = await SecureSocket.secure(
          socket,
          context: SecurityContext(withTrustedRoots: false),
          onBadCertificate: (certificate) {
            return true;
          },
        );

        command = await _connection.connectWithSocket(secureSocket);

        // command = await _connection.connectSecure(host, port);

        if (password != null) {
          await command.send_object(['AUTH', password]);
          Pluggable.logger.v(
            "Successfully authenticated to Redis Cache",
            tag: '$runtimeType',
          );
        }

        await command.send_object(['SELECT', 0]);

        final hasLock = await acquireLock('dart_$T', 'DB_OPEN_$lockIdentity');
        if (!hasLock) {
          throw LockAcquisitionException('Unable to achieve lock');
        }

        final allKeys = (await keys)
            .where((key) {
              return !key.endsWith('_lock');
            })
            .where((key) => key.startsWith('dart_'))
            .toList();

        final indexes = <String, String>{};

        for (final key in allKeys) {
          indexes[key] = await _rawValue(key);
        }

        dbIdx = switch (indexes.keys.contains('dart_$T')) {
          true => int.parse(indexes['dart_$T']!),
          false => switch (indexes.length) {
              0 => 1,
              1 => 2,
              _ => 1 +
                  indexes.values.map((e) => int.parse(e)).reduce(
                        (a, b) => max(a, b),
                      ),
            },
        };

        Pluggable.logger.v(
          'DBX $dbIdx SET FOR $T',
          tag: '$runtimeType',
        );

        await command.send_object(['SETNX', 'dart_$T', dbIdx]);
        await releaseLock('dart_$T', 'DB_OPEN_$lockIdentity');
        await command.send_object(['SELECT', dbIdx]);

        _open = true;
      });
    } on SocketException catch (e) {
      throw Exception('Socket error: $e');
    } on HandshakeException catch (e) {
      throw SecurityException('Handshake error: $e');
    } on LockAcquisitionException catch (_) {
      rethrow; // Rethrow the lock-specific exception
    } catch (e) {
      throw OpenException('Failed to open connection: $e');
    }
  }

  Future<bool> isExtLocked(String key, String trace) async {
    if (!_open) return false;

    final lockKey = '${key}_lock';

    final result = await command.get(lockKey);

    return result != null &&
        result is String &&
        result.isNotEmpty &&
        result != trace;
  }

  Future<bool> acquireLock(
    String key,
    String trace, [
    int attempts = 1,
    int maxAttempts = 0,
    int attemptDelay = 1000,
  ]) async {
    if (!_open && !trace.contains('DB_OPEN')) return false;

    final lockKey = '${key}_lock';
    Pluggable.logger.v(
      '${Isolate.current.debugName} - $trace trying to lock $lockKey for $lockReleaseTimeout',
      tag: '$runtimeType',
    );

    final result = await Future.wait([
      command.send_object(
        ['SET', lockKey, trace, 'NX', 'PX', lockReleaseTimeout],
      ),
      command.get(lockKey),
    ]);

    bool hasLock = result.first == 'OK' || result[1] == trace;

    if (hasLock) {
      Pluggable.logger.v(
        '${Isolate.current.debugName} - $trace locked $lockKey for $lockReleaseTimeout',
        tag: '$runtimeType',
      );
    }

    if (hasLock) {
      return true;
    } else if (maxAttempts > 0 && attempts >= maxAttempts) {
      return false;
    } else {
      await Future.delayed(
        Duration(
          milliseconds: attemptDelay,
        ),
      );

      return acquireLock(
        key,
        trace,
        attempts + 1,
        maxAttempts,
        attemptDelay,
      );
    }
  }

  Future releaseLock(String key, String trace) async {
    if (!_open) return;

    await ensureInitialized();

    final lockKey = '${key}_lock';
    Pluggable.logger.v(
      '${Isolate.current.debugName} - $trace releasing $lockKey',
      tag: '$runtimeType',
    );

    // Start transaction on key
    // await command.send_object(['WATCH', lockKey]);

    // Read and check if lock is the same
    var keyId = await command.get(lockKey);

    if (keyId != trace) {
      // return command.send_object(['UNWATCH']);
    }

    // Remove the lock if it matches
    if (keyId == trace) {
      return _transLock.synchronized(
        () async {
          // await command.send_object(['MULTI']);
          await command.send_object(['DEL', lockKey]);
          // await command.send_object(['EXEC']);
          Pluggable.logger.v(
            '${Isolate.current.debugName} - Released lock',
            tag: '$runtimeType',
          );
        },
        timeout: const Duration(milliseconds: 6000),
      );
    } else {
      // Cancel transaction if it doesn't match
      // await command.send_object(['UNWATCH']);
    }
  }

  Future<Iterable<String>> get keys {
    return command.send_object(['KEYS', '*']).then((result) {
      if (result is! List) {
        return [];
      }

      return result.map((e) {
        return e as String;
      });
    });
  }

  Future<String> _rawValue(String key) async {
    await ensureInitialized();

    return command.send_object(['GET', key]).then((result) {
      if (result is! String) {
        return '';
      }

      return result;
    });
  }

  Future<bool> containsKey(String key) async {
    await ensureInitialized();

    return command.send_object(['EXISTS', key]).then((result) {
      return result == 1;
    });
  }

  Future<void> dump() {
    return command.send_object(['FLUSHALL', 'SYNC']);
  }

  Future<void> put(
    String key,
    T? entry, [
    String? trace,
  ]) async {
    await ensureInitialized();

    final value = switch (fromEncodable == null || entry == null) {
      true => entry,
      false => jsonEncode(
          (entry as dynamic).toJson(),
        ),
    };

    final String identity = trace ?? lockIdentity;

    // Pluggable.logger.v('${Isolate.current.debugName} - ID = $identity');

    return acquireLock(key, identity).then((hasLock) {
      if (!hasLock) {
        throw Exception('Unable to achieve lock on key $key');
      }

      if (value == null) {
        return command.send_object([
          'DEL',
          key,
        ]).then((_) async {
          return releaseLock(key, identity).then((_) {
            return null;
          });
        });
      } else {
        return command.send_object([
          'SET',
          key,
          '$value',
          ...expirationParams,
        ]).then((value) async {
          return releaseLock(key, identity).then((_) {
            return value;
          });
        });
      }
    });
  }

  Future<bool> putIfAbsent(
    String key,
    T entry, [
    String? trace,
  ]) async {
    Pluggable.logger.v(
      'PUTTING $key',
      tag: '$runtimeType',
    );
    await ensureInitialized();

    final value = switch (fromEncodable == null) {
      true => entry,
      false => jsonEncode(
          (entry as dynamic).toJson(),
        ),
    };

    final String identity = trace ?? lockIdentity;

    return acquireLock(key, identity).then((hasLock) {
      if (!hasLock) {
        throw Exception('Unable to achieve lock on key $key');
      }

      return command.send_object(
        ['SET', key, '$value', 'NX', ...expirationParams],
      ).then((value) {
        return releaseLock(key, identity).then((_) {
          return value == 1;
        });
      });
    });
  }

  Future<void> ensureInitialized() async {
    try {
      final r = await command.send_object(['PING']);

      bool pong = r == "PONG";

      if (!pong) {
        try {
          await close();
        } catch (e) {
          Pluggable.logger.e(
            e.toString(),
            err: e,
            stackTrace: StackTrace.current,
            tag: '$runtimeType',
          );
        }

        await open();
      }
    } catch (e) {
      Pluggable.logger.e(
        e.toString(),
        err: e,
        stackTrace: StackTrace.current,
        tag: '$runtimeType',
      );

      try {
        await close();
      } catch (e) {
        Pluggable.logger.e(
          e.toString(),
          err: e,
          stackTrace: StackTrace.current,
          tag: '$runtimeType',
        );
      }

      _open = false;

      await open();
    }
  }

  Future<T?> get(String key) async {
    await ensureInitialized();

    return command.get(key).then((value) {
      if (value != null) {
        return switch (fromEncodable == null) {
          true => value as T?,
          false => fromEncodable!(jsonDecode(value)),
        };
      }

      return null;
    });
  }

  Future<T?> getAndPut(
    String key,
    T value, [
    String? trace,
  ]) async {
    await ensureInitialized();

    Map<String, dynamic> map = (value as dynamic).toJson();

    final String identity = trace ?? lockIdentity;

    return acquireLock(key, identity).then((hasLock) {
      if (!hasLock) {
        throw Exception('Unable to achieve lock on key $key');
      }

      return command.send_object(
        ['SET', key, jsonEncode(map), ...expirationParams, 'GET'],
      ).then((value) {
        return releaseLock(key, identity).then((_) {
          if (value != null) {
            return switch (fromEncodable == null) {
              true => value as T?,
              false => fromEncodable!(jsonDecode(value)),
            };
          }

          return null;
        });
      });
    });
  }
}

class RedisStoragePlug extends PluggableStorageProvider {
  bool initialized = false;

  final Map<Type, _RedisAdapter> _caches = {};

  final String host;
  final int port;
  final String? password;
  final _openLock = Lock();

  RedisStoragePlug({
    required this.host,
    required this.port,
    this.password,
  });

  int get len => _caches.length;

  _RedisAdapter<T> _getCache<T extends Object>() {
    assert(_caches.containsKey(T), 'Vault of type $T not open');
    return _caches[T]! as _RedisAdapter<T>;
  }

  @override
  Future<Map<String, dynamic>> getAllForType(
    String type, [
    String? key,
  ]) async {
    return _openLock.synchronized(() async {
      final entry = _caches.entries.firstWhereOrNull((e) {
        return e.value.type.toString() == type;
      })?.value;

      if (entry != null) {
        try {
          return await entry.getAll(key);
        } catch (e) {
          return {
            'error': e.toString(),
          };
        }
      }

      return {
        'result': 'No entries found for type $type',
      };
    });
  }

  @override
  Future<PluggableStorageProvider> init() async {
    if (initialized) {
      return this;
    }

    initialized = true;

    Pluggable.logger.v(
      '${Isolate.current.debugName} - Redis store initialized',
      tag: '$runtimeType',
    );

    return this;
  }

  Future<Map<String, dynamic>> ping() async {
    return _openLock.synchronized(() async {
      final results = <String, dynamic>{};

      for (final cache in _caches.values) {
        try {
          final r = await cache.ping();

          results[cache.type.toString()] = {
            'reachable': r,
            'idx': cache.dbIdx,
          };
        } catch (e) {
          results[cache.type.toString()] = {
            'reachable': false,
          };
        }
      }

      return results;
    });
  }

  @override
  Future<void> open<T extends Object>({
    required Duration expiry,
    DecodeFunc<T>? fromEncodable,
  }) async {
    return _openLock.synchronized(() async {
      // Pluggable.logger.v('${Isolate.current.debugName} - OPENING $T');

      if (_caches.containsKey(T) && _caches[T]!._open) {
        // Pluggable.logger.v('Cannot reopen a cache without first closing it.');
        return;
      }

      fromEncodable ??= Pluggable.storage.getDecoder<T>();

      if (!isPrimitiveType<T>() && fromEncodable == null) {
        throw Exception(
          'Must provide fromEncodable for non-primitive types, or register a decoder before opening',
        );
      }

      await init();

      _caches[T] = _RedisAdapter<T>(
        host: host,
        port: port,
        password: password,
        fromEncodable: fromEncodable,
        expiresIn: expiry,
      );

      await _caches[T]!.open();
    });
  }

  @override
  Future<Iterable<String>> keys<T extends Object>() {
    return _getCache<T>().keys;
  }

  @override
  Future<bool> containsKey<T extends Object>(String key) {
    return _getCache<T>().containsKey(key);
  }

  @override
  Future<PluggableStorageProvider> close<T extends Object>() async {
    await _caches[T]?.close();
    return this;
  }

  @override
  Future<PluggableStorageProvider> dump<T extends Object>() async {
    await _getCache<T>().dump();
    return this;
  }

  @override
  Future<void> put<T extends Object>(
    String key,
    T? value, [
    String? trace,
  ]) {
    return _getCache<T>().put(key, value, trace).then((_) {
      resolveInFlightRequest<T>(key, value);
    });
  }

  @override
  Future<bool> putIfAbsent<T extends Object>(
    String key,
    T value, [
    String? trace,
  ]) {
    return _getCache<T>().putIfAbsent(key, value);
  }

  @override
  Future<T?> get<T extends Object>(
    String key, [
    Fetch<T>? fetch,
    String? trace,
  ]) async {
    final cache = _getCache<T>();

    await cache.open();

    T? value = await cache.get(key);

    if (value == null && fetch != null) {
      await Future.delayed(
        Duration(
          milliseconds: Random().nextInt(400) + 150,
        ),
      );
    }

    final String identity = trace ?? cache.lockIdentity;

    if (await cache.isExtLocked(key, identity)) {
      // Pluggable.logger.v('${Isolate.current.debugName} - EXT LOCKED');
      await Future.delayed(const Duration(milliseconds: 200));
      return get<T>(key, fetch, trace);
    } else if (isKeyInFlight<T>(key)) {
      // Pluggable.logger.v('${Isolate.current.debugName} - IN FLIGHT');
      return inFlightRequest<T>(key);
    }

    markAsInFlight<T>(key);

    value ??= await cache.get(key);

    if (value == null && fetch != null) {
      // Pluggable.logger.v('${Isolate.current.debugName} - FETCH ACQ LOCK');

      bool hasLock = await cache.acquireLock(key, identity);

      // Pluggable.logger.v('${Isolate.current.debugName} - ACQUIRED IN GET');

      if (!hasLock) {
        throw Exception('Unable to achieve lock on key $key');
      }

      final fetchedValue = await fetch();

      if (fetchedValue != null) {
        await put<T>(key, fetchedValue, trace);
        // Pluggable.logger.v('${Isolate.current.debugName} - SET $fetchedValue');
        return fetchedValue;
      }
    } else if (value != null) {
      resolveInFlightRequest<T>(key, value);
    }

    removeInFlight<T>(key);

    await cache.releaseLock(key, trace ?? '');

    return value;
  }

  @override
  Future<T?> getAndPut<T extends Object>(
    String key,
    T value, [
    String? trace,
  ]) {
    return _getCache<T>().getAndPut(
      key,
      value,
    );
  }
}
