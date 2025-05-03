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

/// Internal adapter class for Redis operations.
///
/// This class handles the low-level Redis operations and provides
/// thread-safe access to Redis data. It manages connections, locks,
/// and data serialization/deserialization.
///
/// The adapter supports:
/// - Connection management
/// - Lock acquisition and release
/// - Data expiration
/// - Type-safe data storage and retrieval
class _RedisAdapter<T extends Object> {
  /// The Redis command interface.
  late Command command;

  /// The Redis database index.
  late int dbIdx;

  /// The type of data being stored.
  final Type type;

  /// The Redis server host.
  final String host;

  /// The Redis server port.
  final int port;

  /// The Redis server password, if any.
  final String? password;

  /// Timeout for lock release in milliseconds.
  final int lockReleaseTimeout;

  /// Number of retries for lock acquisition.
  final int lockRetries;

  /// Interval between lock acquisition retries in milliseconds.
  final int lockRetryInterval;

  /// The Redis connection.
  final RedisConnection _connection;

  /// Unique identifier for this adapter instance.
  final String lockIdentity;

  /// Duration after which stored items expire.
  final Duration? expiresIn;

  /// Function to decode stored values.
  final DecodeFunc<T>? fromEncodable;

  /// Whether the adapter is connected to Redis.
  bool _open = false;

  /// Lock for transaction operations.
  final _transLock = Lock();

  /// Lock for connection operations.
  final _openLock = Lock();

  /// Creates a new [_RedisAdapter] with the given configuration.
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

  /// Gets the Redis expiration parameters.
  List<dynamic> get expirationParams => switch (expiresIn == null) {
        true => [],
        false => ['PX', expiresIn!.inMilliseconds],
      };

  /// Closes the Redis connection.
  Future<void> close() async {
    if (!_open) {
      return;
    }

    return command.get_connection().close();
  }

  /// Pings the Redis server to check connectivity.
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

  /// Gets all stored values, optionally filtered by key.
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

  /// Opens a connection to the Redis server.
  ///
  /// This method:
  /// 1. Establishes a secure connection
  /// 2. Authenticates if a password is provided
  /// 3. Selects the appropriate database
  /// 4. Acquires necessary locks
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
      rethrow;
    } catch (e) {
      throw OpenException('Failed to open connection: $e');
    }
  }

  /// Checks if a key is locked by another process.
  Future<bool> isExtLocked(String key, String trace) async {
    if (!_open) return false;

    final lockKey = '${key}_lock';

    final result = await command.get(lockKey);

    return result != null &&
        result is String &&
        result.isNotEmpty &&
        result != trace;
  }

  /// Attempts to acquire a lock for a key.
  ///
  /// This method will retry acquiring the lock up to [maxAttempts] times,
  /// waiting [attemptDelay] milliseconds between attempts.
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

  /// Releases a lock for a key.
  Future releaseLock(String key, String trace) async {
    if (!_open) return;

    await ensureInitialized();

    final lockKey = '${key}_lock';
    Pluggable.logger.v(
      '${Isolate.current.debugName} - $trace releasing $lockKey',
      tag: '$runtimeType',
    );

    var keyId = await command.get(lockKey);

    if (keyId == trace) {
      return _transLock.synchronized(
        () async {
          await command.send_object(['DEL', lockKey]);
          Pluggable.logger.v(
            '${Isolate.current.debugName} - Released lock',
            tag: '$runtimeType',
          );
        },
        timeout: const Duration(milliseconds: 6000),
      );
    }
  }

  /// Gets all keys in the current database.
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

  /// Gets the raw string value for a key.
  Future<String> _rawValue(String key) async {
    await ensureInitialized();

    return command.send_object(['GET', key]).then((result) {
      if (result is! String) {
        return '';
      }

      return result;
    });
  }

  /// Checks if a key exists in the database.
  Future<bool> containsKey(String key) async {
    await ensureInitialized();

    return command.send_object(['EXISTS', key]).then((result) {
      return result == 1;
    });
  }

  /// Clears all data from the current database.
  Future<void> dump() {
    return command.send_object(['FLUSHALL', 'SYNC']);
  }

  /// Stores a value in the database.
  ///
  /// If the value is null, the key is removed from the database.
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

  /// Stores a value in the database only if the key doesn't exist.
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

  /// Ensures the Redis connection is initialized and healthy.
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

  /// Retrieves a value from the database.
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

  /// Retrieves a value and replaces it with a new value atomically.
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

/// A storage implementation using Redis as the backend.
///
/// This class provides persistent storage using Redis, a fast in-memory
/// data store. It supports:
/// - Thread-safe operations
/// - Data expiration
/// - Locking mechanisms
/// - Type-safe data storage and retrieval
///
/// Example usage:
/// ```dart
/// final storage = RedisStoragePlug(
///   host: 'localhost',
///   port: 6379,
///   password: 'your_password',
/// );
/// await storage.init();
/// await storage.open<String>(expiry: Duration(hours: 1));
/// await storage.put('key', 'value');
/// final value = await storage.get<String>('key');
/// ```
class RedisStoragePlug extends PluggableStorageProvider {
  /// Whether the storage has been initialized.
  bool initialized = false;

  /// Map of type to Redis adapters.
  final Map<Type, _RedisAdapter> _caches = {};

  /// The Redis server host.
  final String host;

  /// The Redis server port.
  final int port;

  /// The Redis server password, if any.
  final String? password;

  /// Lock for connection operations.
  final _openLock = Lock();

  /// Creates a new [RedisStoragePlug] with the given configuration.
  RedisStoragePlug({
    required this.host,
    required this.port,
    this.password,
  });

  /// Gets the number of open caches.
  int get len => _caches.length;

  /// Gets the Redis adapter for the specified type.
  _RedisAdapter<T> _getCache<T extends Object>() {
    assert(_caches.containsKey(T), 'Vault of type $T not open');
    return _caches[T]! as _RedisAdapter<T>;
  }

  /// Gets all stored values for a specific type, optionally filtered by key.
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

  /// Initializes the storage provider.
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

  /// Pings all open Redis connections to check their health.
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

  /// Opens a cache for the specified type with the given configuration.
  @override
  Future<void> open<T extends Object>({
    required Duration expiry,
    DecodeFunc<T>? fromEncodable,
  }) async {
    return _openLock.synchronized(() async {
      if (_caches.containsKey(T) && _caches[T]!._open) {
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

  /// Returns all keys stored for the specified type.
  @override
  Future<Iterable<String>> keys<T extends Object>() {
    return _getCache<T>().keys;
  }

  /// Checks if a key exists in the storage for the specified type.
  @override
  Future<bool> containsKey<T extends Object>(String key) {
    return _getCache<T>().containsKey(key);
  }

  /// Closes the cache for the specified type.
  @override
  Future<PluggableStorageProvider> close<T extends Object>() async {
    await _caches[T]?.close();
    return this;
  }

  /// Clears all data of the specified type from the storage.
  @override
  Future<PluggableStorageProvider> dump<T extends Object>() async {
    await _getCache<T>().dump();
    return this;
  }

  /// Stores a value in the storage with the specified key.
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

  /// Stores a value in the storage only if the key doesn't already exist.
  @override
  Future<bool> putIfAbsent<T extends Object>(
    String key,
    T value, [
    String? trace,
  ]) {
    return _getCache<T>().putIfAbsent(key, value);
  }

  /// Retrieves a value from storage by key.
  ///
  /// If the key doesn't exist and a [fetch] function is provided,
  /// it will be called to retrieve the value, which will then be stored.
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
      await Future.delayed(const Duration(milliseconds: 200));
      return get<T>(key, fetch, trace);
    } else if (isKeyInFlight<T>(key)) {
      return inFlightRequest<T>(key);
    }

    markAsInFlight<T>(key);

    value ??= await cache.get(key);

    if (value == null && fetch != null) {
      bool hasLock = await cache.acquireLock(key, identity);

      if (!hasLock) {
        throw Exception('Unable to achieve lock on key $key');
      }

      final fetchedValue = await fetch();

      if (fetchedValue != null) {
        await put<T>(key, fetchedValue, trace);
        return fetchedValue;
      }
    } else if (value != null) {
      resolveInFlightRequest<T>(key, value);
    }

    removeInFlight<T>(key);

    await cache.releaseLock(key, trace ?? '');

    return value;
  }

  /// Retrieves a value from storage and replaces it with a new value.
  @override
  Future<T?> getAndPut<T extends Object>(
    String key,
    T value, [
    String? trace,
  ]) {
    return _getCache<T>().getAndPut(key, value, trace);
  }
}
