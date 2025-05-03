import 'package:pluggable/pluggable.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_hive/stash_hive.dart';

/// A secure storage implementation using Hive as the backend.
///
/// This class provides encrypted storage using Hive, a lightweight and fast
/// key-value database. It supports:
/// - Data encryption
/// - Automatic expiration
/// - Event listeners for cache operations
/// - Thread-safe operations
///
/// Example usage:
/// ```dart
/// final storage = SecureStoragePlug();
/// await storage.init();
/// await storage.open<String>(expiry: Duration(hours: 1));
/// await storage.put('key', 'value');
/// final value = await storage.get<String>('key');
/// ```
class SecureStoragePlug extends PluggableStorageProvider {
  /// The underlying Hive cache store.
  late final HiveDefaultCacheStore _store;

  /// Whether the storage has been initialized.
  bool initialized = false;

  /// Map of type to cache instances.
  final Map<Type, Cache> _caches = {};

  /// Gets the cache instance for the specified type.
  ///
  /// Throws an assertion error if the cache for the type hasn't been opened.
  Cache<T> getCache<T>() {
    assert(_caches.containsKey(T), 'Vault of type $T not open');
    return _caches[T]! as Cache<T>;
  }

  /// Initializes the storage provider.
  ///
  /// Creates a new Hive cache store with default settings.
  /// Returns the storage provider instance for method chaining.
  @override
  Future<PluggableStorageProvider> init() async {
    if (initialized) {
      return this;
    }

    // Creates a store
    return await newHiveDefaultCacheStore().then((store) {
      _store = store;
      initialized = true;
      Pluggable.logger.v(
        'Secure vault store initialized',
        tag: '$runtimeType',
      );
      return this;
    });
  }

  /// Opens a cache for the specified type with the given configuration.
  ///
  /// [expiry] specifies how long items should be cached before expiring.
  /// [fromEncodable] is an optional function to decode stored values.
  ///
  /// Throws an exception if a non-primitive type is used without a decoder.
  @override
  Future<void> open<T extends Object>({
    required Duration expiry,
    DecodeFunc<T>? fromEncodable,
  }) async {
    fromEncodable ??= Pluggable.storage.getDecoder<T>();

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
        return Pluggable.logger.v(
          'Key "${event.entry.key}" added to the vault',
          tag: '$runtimeType',
        );
      })
      ..on<CacheEntryUpdatedEvent<T>>().listen((event) {
        Pluggable.logger.v(
          'Key "${event.newEntry.key}" updated in the vault',
          tag: '$runtimeType',
        );
        Pluggable.logger.v(
          'Old Expiry: ${event.oldEntry.expiryTime}',
          tag: '$runtimeType',
        );
        Pluggable.logger.v(
          'New Expiry: ${event.newEntry.expiryTime}',
          tag: '$runtimeType',
        );
      });
  }

  /// Returns all keys stored for the specified type.
  @override
  Future<Iterable<String>> keys<T extends Object>() {
    return getCache<T>().keys;
  }

  /// Checks if a key exists in the storage for the specified type.
  ///
  /// Returns `true` if the key exists, `false` otherwise.
  @override
  Future<bool> containsKey<T extends Object>(String key) {
    return getCache<T>().containsKey(key);
  }

  /// Closes the cache for the specified type.
  ///
  /// Returns the storage provider instance for method chaining.
  @override
  Future<PluggableStorageProvider> close<T extends Object>() async {
    await _caches[T]?.close();
    return this;
  }

  /// Clears all data of the specified type from the storage.
  ///
  /// Returns the storage provider instance for method chaining.
  @override
  Future<PluggableStorageProvider> dump<T extends Object>() async {
    await getCache<T>().clear();
    return this;
  }

  /// Stores a value in the storage with the specified key.
  ///
  /// If the value is null, the key is removed from the storage.
  /// If there are any in-flight requests for this key, they are resolved.
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

  /// Stores a value in the storage only if the key doesn't already exist.
  ///
  /// Returns `true` if the value was stored, `false` if the key already existed.
  @override
  Future<bool> putIfAbsent<T extends Object>(
    String key,
    T value, [
    String? trace,
  ]) {
    return getCache<T>().putIfAbsent(key, value);
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

  /// Retrieves a value from storage and replaces it with a new value.
  ///
  /// Returns the previous value, or `null` if the key didn't exist.
  @override
  Future<T?> getAndPut<T extends Object>(
    String key,
    T value, [
    String? trace,
  ]) {
    return getCache<T>().getAndPut(key, value);
  }
}
