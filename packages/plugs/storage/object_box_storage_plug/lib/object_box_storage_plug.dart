import 'dart:async';
import 'dart:isolate';
import 'dart:io';
import 'package:stash/stash_api.dart';
import 'package:stash_objectbox/stash_objectbox.dart';
import 'package:synchronized/synchronized.dart';
import 'package:pluggable/pluggable.dart';

class ObjectBoxStoragePlug extends PluggableStorage {
  late final ObjectboxCacheStore _store;

  bool initialized = false;

  final Map<Type, Cache> _caches = {};
  final Lock lock = Lock();

  Cache<T> getCache<T extends Object>() {
    assert(_caches.containsKey(T), 'Vault of type $T not open');
    return _caches[T]! as Cache<T>;
  }

  @override
  Future<PluggableStorage> init() async {
    if (initialized) {
      return this;
    }

    initialized = true;

    return newObjectboxLocalCacheStore(
      path: '${Directory.systemTemp.path}_${Isolate.current.debugName}',
    ).then((store) {
      _store = store;
      print('Cache store initialized');
      return this;
    });
  }

  @override
  Future<void> open<T extends Object>({
    required Duration expiry,
    DecodeFunc<T>? fromEncodable,
  }) async {
    fromEncodable ??= getDecoder<T>();

    if (!isPrimitiveType<T>() && fromEncodable == null) {
      throw Exception(
        'Must provide fromEncodable for non-primitive types, or register a decoder before opening',
      );
    }

    await init();

    _caches[T] = await _store.cache<T>(
      name: '$T',
      fromEncodable: fromEncodable,
      eventListenerMode: EventListenerMode.synchronous,
      expiryPolicy: TouchedExpiryPolicy(expiry),
    )
      ..on<CacheEntryCreatedEvent<T>>().listen((event) {
        return print('Key "${event.entry.key}" added to the vault');
      })
      ..on<CacheEntryUpdatedEvent<T>>().listen((event) {
        print('Key "${event.newEntry.key}" updated in the vault');
        print('Old Expiry: ${event.oldEntry.expiryTime}');
        print('New Expiry: ${event.newEntry.expiryTime}');
      });

    print('CACHE LEN: ${_caches.length}');
  }

  @override
  Future<Iterable<String>> keys<T extends Object>() {
    return lock.synchronized(() => getCache<T>().keys);
  }

  @override
  Future<bool> containsKey<T extends Object>(String key) {
    return lock.synchronized(() => getCache<T>().containsKey(key));
  }

  @override
  Future<PluggableStorage> close<T extends Object>() async {
    await lock.synchronized(() => _caches[T]?.close());
    return this;
  }

  @override
  Future<PluggableStorage> dump<T extends Object>() async {
    await lock.synchronized(() => getCache<T>().clear());
    return this;
  }

  @override
  Future<void> put<T extends Object>(
      String key,
      T? value, [
        String? trace,
      ]) {
    return lock.synchronized(() async {
      final cache = getCache<T>();

      if (value == null) {
        return await cache.remove(key);
      }

      return cache.put(key, value).then((_) {
        if (isKeyInFlight<T>(key)) {
          resolveInFlightRequest<T>(key, value);
        }
      });
    });
  }

  @override
  Future<bool> putIfAbsent<T extends Object>(
      String key,
      T value, [
        String? trace,
      ]) {
    return lock.synchronized(() => getCache<T>().putIfAbsent(key, value));
  }

  @override
  Future<T?> get<T extends Object>(
      String key, [
        Fetch<T?>? fetch,
        String? trace,
      ]) async {
    return lock.synchronized(() async {
      if (isKeyInFlight<T>(key)) {
        return inFlightRequest<T>(key);
      }

      markAsInFlight<T>(key);

      final cache = getCache<T>();

      final value = await cache.get(key);

      if (value == null && fetch != null) {
        final fetchedValue = await fetch();

        removeInFlight<T>(key);

        if (fetchedValue != null) {
          await put(key, fetchedValue);
          return fetchedValue;
        }
      } else if (value != null) {
        resolveInFlightRequest<T>(key, value);
      }

      removeInFlight<T>(key);

      return value;
    });
  }

  @override
  Future<T?> getAndPut<T extends Object>(
      String key,
      T value, [
        String? trace,
      ]) {
    return lock.synchronized(() => getCache<T>().getAndPut(key, value));
  }
}
