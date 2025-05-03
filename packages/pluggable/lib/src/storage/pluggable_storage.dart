/// Core storage implementation for the Pluggable system.
/// 
/// This class provides a unified interface for both local and remote storage,
/// with support for data decoding and type conversion. It manages the lifecycle
/// of storage providers and handles data serialization/deserialization.
/// 
/// Example usage:
/// ```dart
/// final storage = PluggableStorage(
///   local: LocalStorageProvider(),
///   remote: RemoteStorageProvider(),
/// );
/// 
/// // Add a decoder for a custom type
/// storage.addDecoder<MyType>((data) => MyType.fromJson(data));
/// 
/// // Decode data
/// final myData = storage.decode<MyType>(rawData);
/// ```

import 'package:pluggable/pluggable.dart';

export 'pluggable_storage_provider.dart';

/// Function type for decoding data from a map
typedef DecodeFunc<T> = T Function(Map<String, dynamic>);

/// Function type for fetching data
typedef Fetch<T> = Future<T?> Function();

class PluggableStorage extends Plug<PluggableStorage> {
  /// Map of type decoders for data conversion
  final Map<Type, DecodeFunc> _decoders = {};

  /// Getter for the decoders map
  Map<Type, DecodeFunc> get decoders => _decoders;

  /// Local storage provider
  final PluggableStorageProvider local;

  /// Remote storage provider
  final PluggableStorageProvider remote;

  /// Creates a new PluggableStorage instance
  /// 
  /// [local] - Provider for local storage operations
  /// [remote] - Provider for remote storage operations
  PluggableStorage({
    required this.local,
    required this.remote,
  });

  /// Initializes both local and remote storage providers
  @override
  Future<PluggableStorage> init() async {
    await Future.wait([
      local.init(),
      remote.init(),
    ]);

    return this;
  }

  /// Disposes of both local and remote storage providers
  @override
  Future<PluggableStorage> dispose() async {
    await Future.wait([
      local.dispose(),
      remote.dispose(),
    ]);

    return this;
  }

  /// Adds a decoder for a specific type
  /// 
  /// [decoder] - Function that converts a map to the specified type
  void addDecoder<T>(DecodeFunc<T> decoder) {
    _decoders[T] = decoder;
  }

  /// Checks if a decoder exists for a specific type
  bool hasDecoder<T>() {
    return _decoders.containsKey(T);
  }

  /// Decodes input data to the specified type
  /// 
  /// Throws an assertion error if no decoder is registered for the type
  T decode<T>(dynamic input) {
    assert(hasDecoder<T>());

    return _decoders[T]!(input) as T;
  }

  /// Gets the decoder for a specific type
  /// 
  /// Returns null if no decoder is registered for the type
  DecodeFunc<T>? getDecoder<T>() {
    return _decoders[T] as DecodeFunc<T>?;
  }
}
