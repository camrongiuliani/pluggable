import 'package:pluggable/pluggable.dart';

export 'pluggable_storage_provider.dart';

typedef DecodeFunc<T> = T Function(Map<String, dynamic>);
typedef Fetch<T> = Future<T?> Function();

class PluggableStorage extends Plug<PluggableStorage> {
  final Map<Type, DecodeFunc> _decoders = {};

  Map<Type, DecodeFunc> get decoders => _decoders;

  final PluggableStorageProvider local;

  final PluggableStorageProvider remote;

  PluggableStorage({
    required this.local,
    required this.remote,
  });

  @override
  Future<PluggableStorage> init() async {
    await Future.wait([
      local.init(),
      remote.init(),
    ]);

    return this;
  }

  @override
  Future<PluggableStorage> dispose() async {
    await Future.wait([
      local.dispose(),
      remote.dispose(),
    ]);

    return this;
  }

  void addDecoder<T>(DecodeFunc<T> decoder) {
    _decoders[T] = decoder;
  }

  bool hasDecoder<T>() {
    return _decoders.containsKey(T);
  }

  T decode<T>(dynamic input) {
    assert(hasDecoder<T>());

    return _decoders[T]!(input) as T;
  }

  DecodeFunc<T>? getDecoder<T>() {
    return _decoders[T] as DecodeFunc<T>?;
  }
}
