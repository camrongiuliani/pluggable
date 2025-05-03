import 'package:expire_cache/expire_cache.dart';
import 'package:pluggable/pluggable.dart';

/// A storage implementation using ExpireCache as the backend.
///
/// This class provides in-memory storage with automatic expiration of entries.
/// It uses the [ExpireCache] package to manage cached data with a default
/// expiration time of 10 minutes.
///
/// Example usage:
/// ```dart
/// final storage = ExpireCacheStoragePlug();
/// await storage.open<String>(expiry: Duration(minutes: 5));
/// await storage.put('key', 'value');
/// final value = await storage.get<String>('key');
/// ```
class ExpireCacheStoragePlug extends PluggableStorageProvider {
  /// Map of type to ExpireCache instances.
  final Map<Type, ExpireCache<String, Object?>> _cache = {};

  /// Gets or creates a cache instance for the specified type.
  ///
  /// If a cache doesn't exist for the type, a new one is created with
  /// a default expiration time of 10 minutes.
  ExpireCache<String, T?> _getCache<T extends Object>() {
    return (
      _cache[T] ??= ExpireCache<String, T?>(
        expireDuration: const Duration(
          minutes: 10,
        ),
      ),
    ) as ExpireCache<String, T?>;
  }

  /// Closes the cache for the specified type.
  ///
  /// This implementation is a no-op as ExpireCache doesn't require cleanup.
  @override
  Future<PluggableStorageProvider> close<T extends Object>() async {
    return this;
  }

  /// Checks if a key exists in the storage for the specified type.
  ///
  /// Returns `true` if the key exists, `false` otherwise.
  @override
  Future<bool> containsKey<T extends Object>(String key) async {
    return _cache.containsKey(T) && _cache[T]!.containsKey(key);
  }

  /// Clears all data of the specified type from the storage.
  ///
  /// Returns the storage provider instance for method chaining.
  @override
  Future<PluggableStorageProvider> dump<T extends Object>() async {
    _getCache<T>().clear();
    return super.dump();
  }

  /// Retrieves a value from storage by key.
  ///
  /// If the key doesn't exist and a [fetch] function is provided,
  /// it will be called to retrieve the value, which will then be stored.
  ///
  /// Handles concurrent requests for the same key to prevent duplicate fetches.
  ///
  /// Returns the stored value, or `null` if not found.
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

  /// Retrieves a value from storage and replaces it with a new value.
  ///
  /// Returns the previous value, or `null` if the key didn't exist.
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

  /// Returns all keys stored for the specified type.
  ///
  /// This operation is not supported by ExpireCache.
  @override
  Future<Iterable<String>> keys<T extends Object>() {
    throw UnsupportedError('ExpireCache does not support Keys getter');
  }

  /// Opens a cache for the specified type with the given configuration.
  ///
  /// This implementation only ensures the cache exists for the type.
  @override
  Future<void> open<T extends Object>({
    required Duration expiry,
    DecodeFunc<T>? fromEncodable,
  }) async {
    _getCache<T>();
  }

  /// Stores a value in the storage with the specified key.
  @override
  Future<void> put<T extends Object>(
    String key,
    T? value, [
    String? trace,
  ]) async {
    await _getCache<T>().set(key, value);
  }

  /// Stores a value in the storage only if the key doesn't already exist.
  ///
  /// Returns `true` if the value was stored, `false` if the key already existed.
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
