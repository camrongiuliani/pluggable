import 'package:pluggable_dart_server/pluggable_dart_server.dart';

/// A base module class for server-specific functionality.
///
/// This class extends [PluggableModule] to provide server-specific module
/// capabilities. It should be used as a base class for modules that need
/// to interact with the server environment.
///
/// Example usage:
/// ```dart
/// class MyServerModule extends ServerModule {
///   @override
///   Future<void> init() async {
///     // Initialize module
///   }
/// }
/// ```
class ServerModule extends PluggableModule {
  @override
  Future<PluggableModule> init() async {
    return this;
  }
}
