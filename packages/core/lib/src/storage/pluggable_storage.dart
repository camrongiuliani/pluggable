import 'package:pluggable/pluggable.dart';

abstract class PluggableStorage extends Plug<PluggableStorage> {
  Future<void> flush();

  Future<void> write({
    required String key,
    required String? value,
  });

  Future<String?> read({
    required String key,
    String? defaultValue,
  });
}

class MemoryStoragePlug extends PluggableStorage {
  final Map<String, String> _storage = {};

  @override
  Future<void> flush() async {
    _storage.clear();
  }

  @override
  Future<String?> read({
    required String key,
    String? defaultValue,
  }) async {
    return _storage[key] ?? defaultValue;
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
  }) async {
    _storage[key] = value!;
  }

  @override
  Future<Plug> dispose() async => this;

  @override
  Future<Plug> init() async => this;
}