import 'package:pluggable/pluggable.dart';
import 'package:pluggable/src/storage/in_flight_mixin.dart';

typedef DecodeFunc<T> = T Function(Map<String, dynamic>);
typedef Fetch<T> = Future<T?> Function();

abstract class PluggableStorageProvider extends Plug<PluggableStorageProvider>
    with InFlightMixin {

  @override
  Future<PluggableStorageProvider> init() async {
    return this;
  }

  @override
  Future<PluggableStorageProvider> dispose() async => this;

  Future<Map<String, dynamic>> getAllForType(
    String type, [
    String? key,
  ]) async {
    return {};
  }

  bool isPrimitiveType<T extends Object>() {
    return [
      String,
      int,
      num,
      double,
      bool,
    ].contains(T);
  }

  Future<void> open<T extends Object>({
    required Duration expiry,
    DecodeFunc<T> fromEncodable,
  });

  Future<PluggableStorageProvider> close<T extends Object>() async {
    return this;
  }

  Future<PluggableStorageProvider> dump<T extends Object>() async {
    return this;
  }

  Future<Iterable<String>> keys<T extends Object>();

  Future<bool> containsKey<T extends Object>(String key);

  /// Returns the vault value for the specified [key].
  ///
  /// * [key]: the key
  Future<T?> get<T extends Object>(
    String key, [
    Fetch<T>? fetch,
    String? trace,
  ]);

  /// Add / Replace the vault [value] for the specified [key].
  ///
  /// * [key]: the key
  /// * [value]: the value
  Future<void> put<T extends Object>(
    String key,
    T? value, [
    String? trace,
  ]);

  /// Associates the specified [key] with the given [value]
  ///
  /// * [key]: key with which the specified value is to be associated
  /// * [value]: value to be associated with the specified key
  ///
  /// Returns `true` if a value was set.
  Future<bool> putIfAbsent<T extends Object>(
    String key,
    T value, [
    String? trace,
  ]);

  /// Associates the specified [value] with the specified [key] in this cache,
  /// returning an existing value if one existed. If the cache previously contained
  /// a mapping for the [key], the old value is replaced by the specified value.
  ///
  /// * [key]: key with which the specified value is to be associated
  /// * [value]: value to be associated with the specified key
  ///
  /// The previous value is returned, or `null` if there was no value
  /// associated with the [key] previously.
  Future<T?> getAndPut<T extends Object>(
    String key,
    T value, [
    String? trace,
  ]);
}
