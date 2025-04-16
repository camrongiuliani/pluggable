import 'package:expire_cache/expire_cache.dart';
import 'package:pluggable/pluggable.dart';

class ExpireCacheStoragePlug extends PluggableStorageProvider {
  final Map<Type, ExpireCache<String, Object?>> _cache = {};

  ExpireCache<String, T?> _getCache<T extends Object>() {
    return (
      _cache[T] ??= ExpireCache<String, T?>(
        expireDuration: const Duration(
          minutes: 10,
        ),
      ),
    ) as ExpireCache<String, T?>;
  }

  @override
  Future<PluggableStorageProvider> close<T extends Object>() async {
    return this;
  }

  @override
  Future<bool> containsKey<T extends Object>(String key) async {
    return _cache.containsKey(T) && _cache[T]!.containsKey(key);
  }

  @override
  Future<PluggableStorageProvider> dump<T extends Object>() async {
    _getCache<T>().clear();
    return super.dump();
  }

  @override
  Future<T?> get<T extends Object>(
    String key, [
    Fetch<T>? fetch,
    String? trace,
  ]) async {
    final cache = _getCache<T>();

    if (!cache.isKeyInFlightOrInCache(key)) {
      if (fetch == null) {
        return null;
      }

      cache.markAsInFlight(key);
    } else {
      return await cache.get(key);
    }

    final fetchedValue = await fetch();

    if (fetchedValue != null) {
      cache.set(key, fetchedValue);
    }

    return fetchedValue;
  }

  @override
  Future<T?> getAndPut<T extends Object>(
    String key,
    T value, [
    String? trace,
  ]) async {
    final cache = _getCache<T>();
    final existing = await cache.get(key);
    await cache.set(key, value);
    return existing;
  }

  @override
  Future<Iterable<String>> keys<T extends Object>() {
    throw UnsupportedError('ExpireCache does not support Keys getter');
  }

  @override
  Future<void> open<T extends Object>({
    required Duration expiry,
    DecodeFunc<T>? fromEncodable,
  }) async {
    _getCache<T>();
  }

  @override
  Future<void> put<T extends Object>(
    String key,
    T? value, [
    String? trace,
  ]) async {
    await _getCache<T>().set(key, value);
  }

  @override
  Future<bool> putIfAbsent<T extends Object>(
    String key,
    T value, [
    String? trace,
  ]) async {
    final cache = _getCache<T>();

    bool hasValue = cache.containsKey(key);

    if (hasValue) {
      return false;
    }

    cache.set(key, value);

    return true;
  }
}
