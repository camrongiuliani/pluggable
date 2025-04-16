import 'package:pluggable/pluggable.dart';

class InMemoryStoragePlug extends PluggableStorageProvider {
  final Map<Type, Map<String, Object?>> _cache = {};

  Map<String, T?> _getCache<T extends Object>() {
    return (_cache[T] ??= <String, T?>{}) as Map<String, T?>;
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

  @override
  Future<Iterable<String>> keys<T extends Object>() async {
    return _getCache<T>().keys;
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
    _getCache<T>()[key] = value;
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

    cache[key] = value;

    return true;
  }
}
