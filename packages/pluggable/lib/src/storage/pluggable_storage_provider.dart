/// Abstract base class for storage providers in the Pluggable system.
/// 
/// This class defines the interface for storage operations, including
/// data retrieval, storage, and management. It supports both primitive
/// and complex types, with optional caching and type conversion.
/// 
/// Example usage:
/// ```dart
/// class MyStorageProvider extends PluggableStorageProvider {
///   @override
///   Future<T?> get<T extends Object>(String key, [Fetch<T>? fetch, String? trace]) {
///     // Implementation
///   }
///   
///   // Other method implementations...
/// }
/// ```

import 'package:pluggable/pluggable.dart';
import 'package:pluggable/src/storage/in_flight_mixin.dart';

/// Function type for decoding data from a map
typedef DecodeFunc<T> = T Function(Map<String, dynamic>);

/// Function type for fetching data
typedef Fetch<T> = Future<T?> Function();

abstract class PluggableStorageProvider extends Plug<PluggableStorageProvider>
    with InFlightMixin {

  /// Initializes the storage provider
  @override
  Future<PluggableStorageProvider> init() async {
    return this;
  }

  /// Disposes of the storage provider
  @override
  Future<PluggableStorageProvider> dispose() async => this;

  /// Retrieves all data of a specific type
  /// 
  /// [type] - The type of data to retrieve
  /// [key] - Optional key to filter the data
  Future<Map<String, dynamic>> getAllForType(
    String type, [
    String? key,
  ]) async {
    return {};
  }

  /// Checks if a type is a primitive type
  /// 
  /// Primitive types include String, int, num, double, and bool
  bool isPrimitiveType<T extends Object>() {
    return [
      String,
      int,
      num,
      double,
      bool,
    ].contains(T);
  }

  /// Opens a storage session for a specific type
  /// 
  /// [expiry] - Duration after which the session expires
  /// [fromEncodable] - Function to convert data to the specified type
  Future<void> open<T extends Object>({
    required Duration expiry,
    DecodeFunc<T> fromEncodable,
  });

  /// Closes a storage session for a specific type
  Future<PluggableStorageProvider> close<T extends Object>() async {
    return this;
  }

  /// Dumps all data of a specific type
  Future<PluggableStorageProvider> dump<T extends Object>() async {
    return this;
  }

  /// Gets all keys for a specific type
  Future<Iterable<String>> keys<T extends Object>();

  /// Checks if a key exists for a specific type
  Future<bool> containsKey<T extends Object>(String key);

  /// Retrieves a value for the specified key
  /// 
  /// [key] - The key to retrieve
  /// [fetch] - Optional function to fetch the value if not found
  /// [trace] - Optional trace identifier for debugging
  Future<T?> get<T extends Object>(
    String key, [
    Fetch<T>? fetch,
    String? trace,
  ]);

  /// Stores a value for the specified key
  /// 
  /// [key] - The key to store
  /// [value] - The value to store
  /// [trace] - Optional trace identifier for debugging
  Future<void> put<T extends Object>(
    String key,
    T? value, [
    String? trace,
  ]);

  /// Stores a value for the specified key if it doesn't exist
  /// 
  /// [key] - The key to store
  /// [value] - The value to store
  /// [trace] - Optional trace identifier for debugging
  /// 
  /// Returns true if the value was stored, false if it already existed
  Future<bool> putIfAbsent<T extends Object>(
    String key,
    T value, [
    String? trace,
  ]);

  /// Stores a value for the specified key and returns the previous value
  /// 
  /// [key] - The key to store
  /// [value] - The value to store
  /// [trace] - Optional trace identifier for debugging
  /// 
  /// Returns the previous value, or null if none existed
  Future<T?> getAndPut<T extends Object>(
    String key,
    T value, [
    String? trace,
  ]);
}
