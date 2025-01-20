import 'package:pluggable/pluggable.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_hive/stash_hive.dart';

class SecureStoragePlug extends PluggableStorage {
  late final HiveDefaultCacheStore _store;
  bool initialized = false;

  final Map<Type, Cache> _caches = {};

  Cache<T> getCache<T>() {
    assert(_caches.containsKey(T), 'Vault of type $T not open');
    return _caches[T]! as Cache<T>;
  }

  @override
  Future<PluggableStorage> init() async {
    if (initialized) {
      return this;
    }

    // Creates a store
    return await newHiveDefaultCacheStore().then((store) {
      _store = store;
      initialized = true;
      print('Secure vault store initialized');
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
      name: '${T.runtimeType}',
      fromEncodable: fromEncodable,
      eventListenerMode: EventListenerMode.synchronous,
      expiryPolicy: TouchedExpiryPolicy(expiry),
    )
      ..on<CacheEntryCreatedEvent<T>>().listen((event) {
        print(event.entry.expiryTime);
        return print('Key "${event.entry.key}" added to the vault');
      })
      ..on<CacheEntryUpdatedEvent<T>>().listen((event) {
        print('Key "${event.newEntry.key}" updated in the vault');
        print('Old Expiry: ${event.oldEntry.expiryTime}');
        print('New Expiry: ${event.newEntry.expiryTime}');
      });
  }

  @override
  Future<Iterable<String>> keys<T extends Object>() {
    return getCache<T>().keys;
  }

  @override
  Future<bool> containsKey<T extends Object>(String key) {
    return getCache<T>().containsKey(key);
  }

  @override
  Future<PluggableStorage> close<T extends Object>() async {
    await _caches[T]?.close();
    return this;
  }

  @override
  Future<PluggableStorage> dump<T extends Object>() async {
    await getCache<T>().clear();
    return this;
  }

  @override
  Future<void> put<T extends Object>(
      String key,
      T? value, [
        String? trace,
      ]) {
    final cache = getCache<T>();

    if (value == null) {
      return cache.remove(key);
    }

    return cache.put(key, value).then((_) {
      if (isKeyInFlight<T>(key)) {
        resolveInFlightRequest<T>(key, value);
      }
    });
  }

  @override
  Future<bool> putIfAbsent<T extends Object>(
      String key,
      T value, [
        String? trace,
      ]) {
    return getCache<T>().putIfAbsent(key, value);
  }

  @override
  Future<T?> get<T extends Object>(
      String key, [
        Fetch<T>? fetch,
        String? trace,
      ]) async {
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
  }

  @override
  Future<T?> getAndPut<T extends Object>(
      String key,
      T value, [
        String? trace,
      ]) {
    return getCache<T>().getAndPut(key, value);
  }
}
