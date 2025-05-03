import 'package:pluggable/pluggable.dart';

/// An in-memory storage implementation of [PluggableStorageProvider].
///
/// This class provides a simple in-memory storage solution that stores data
/// in a map structure. It's useful for temporary storage or caching purposes.
///
/// Example usage:
/// ```dart
/// final storage = InMemoryStoragePlug();
/// await storage.put('key', 'value');
/// final value = await storage.get<String>('key');
/// ```
class InMemoryStoragePlug extends PluggableStorageProvider {
  /// Internal cache map that stores data by type and key.
  ///
  /// The outer map uses the type as the key, and the inner map uses
  /// the storage key as the key and the stored value as the value.
  final Map<Type, Map<String, Object?>> _cache = {};

  /// Gets or creates a cache map for the specified type.
  ///
  /// Returns a map of [String] keys to values of type [T].
  Map<String, T?> _getCache<T extends Object>() {
    return (_cache[T] ??= <String, T?>{}) as Map<String, T?>;
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
  /// Returns the stored value, or `null` if not found.
  @override
  Future<T?> get<T extends Object>(
    String key, [
    Fetch<T>? fetch,
    String? trace,
  ]) async {
    final cache = _getCache<T>();

    if (cache.containsKey(key)) {
      return cache[key];
    } else if (fetch != null) {
      final fetchedValue = await fetch();

      if (fetchedValue != null) {
        cache[key] = fetchedValue;
      }

      return fetchedValue;
    }

    return null;
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
    final existing = cache[key];
    cache[key] = value;
    return existing;
  }

  /// Returns all keys stored for the specified type.
  @override
  Future<Iterable<String>> keys<T extends Object>() async {
    return _getCache<T>().keys;
  }

  /// Opens storage for the specified type with optional configuration.
  ///
  /// This implementation only ensures the cache map exists for the type.
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
    _getCache<T>()[key] = value;
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

    cache[key] = value;

    return true;
  }
}
