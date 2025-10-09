import 'dart:async';
import 'dart:io';

import 'package:pluggable/pluggable.dart' as core;
import 'package:pluggable_dart_server/pluggable_dart_server.dart';

/// Runs a Pluggable HTTP server with the specified configuration.
///
/// This function initializes the Pluggable system with the provided modules and plugins,
/// then starts an HTTP server with the specified configuration.
///
/// Example usage:
/// ```dart
/// final server = await runPluggableServer(
///   server: DartServerPlug(ip: '0.0.0.0', port: 8080),
///   modules: [MyModule()],
///   mounts: ['/api'],
/// );
/// ```
///
/// [server]: The server configuration and implementation.
/// [modules]: List of modules to initialize.
/// [mounts]: List of URL paths to mount the server on.
/// [storagePlugin]: Optional storage plugin for data persistence.
/// [analyticsPlugin]: Optional analytics plugin for tracking.
/// [loggingPlugin]: Optional logging plugin for server logs.
/// [diPlugin]: Optional dependency injection plugin.
/// [poweredByHeader]: Optional header value for the 'X-Powered-By' response header.
/// [securityContext]: Optional security context for HTTPS.
/// [shared]: Whether to use a shared socket.
Future<HttpServer> runPluggableServer({
  required DartServerPlug server,
  List<PluggableModule> modules = const [],
  List<String> mounts = const ['/'],
  PluggableStorage? storagePlugin,
  PluggableAnalytics? analyticsPlugin,
  PluggableLogger? loggingPlugin,
  PluggableDI? diPlugin,
  String? poweredByHeader = 'Dart Pluggable',
  SecurityContext? securityContext,
  bool shared = false,
}) async {
  final pluggable = await initPluggable(
    modules: modules,
    storagePlugin: storagePlugin,
    analyticsPlugin: analyticsPlugin,
    loggingPlugin: ConsoleLoggerPlug(),
    diPlugin: diPlugin,
    server: server,
  );

  if (loggingPlugin != null) {
    await pluggable.plugin<PluggableLogger>(
      loggingPlugin,
      notify: false,
      allowReassignment: true,
    );
  }

  return Pluggable.server.run(
    ip: server.ip,
    port: server.port,
    mounts: mounts.where((s) => s.isNotEmpty).toList(),
    poweredByHeader: poweredByHeader,
    securityContext: securityContext,
    shared: shared,
  );
}

/// Initializes the Pluggable system with the specified configuration.
///
/// This function sets up the Pluggable system with the provided modules and plugins.
/// If the system is already initialized, it will be disposed before reinitializing.
///
/// [server]: The server configuration and implementation.
/// [modules]: List of modules to initialize.
/// [storagePlugin]: Optional storage plugin for data persistence.
/// [analyticsPlugin]: Optional analytics plugin for tracking.
/// [loggingPlugin]: Optional logging plugin for server logs.
/// [diPlugin]: Optional dependency injection plugin.
Future<core.PluggableImpl> initPluggable({
  required DartServerPlug server,
  List<PluggableModule> modules = const [],
  PluggableStorage? storagePlugin,
  PluggableAnalytics? analyticsPlugin,
  PluggableLogger? loggingPlugin,
  PluggableDI? diPlugin,
}) async {
  if (core.PluggableImpl.instance?.initialized ?? false) {
    await core.PluggableImpl.instance!.dispose();
  }

  final pluggable = await core.initPluggable(
    modules: modules,
    storagePlugin: storagePlugin,
    analyticsPlugin: analyticsPlugin,
    loggingPlugin: loggingPlugin,
    diPlugin: diPlugin,
  );

  await pluggable.plugin<DartServerPlug>(server);

  return pluggable;
}

/// Extension on [PluggableImpl] to provide server-specific functionality.
extension PluggableDartServer on PluggableImpl {
  /// Gets the server plugin instance.
  DartServerPlug get server => get();
}

/// A mixin that provides server-specific functionality for Pluggable modules.
///
/// This mixin should be used by modules that need to interact with the server
/// environment and require initialization with seeding capabilities.
///
/// Example usage:
/// ```dart
/// class MyModule extends PluggableModule with PluggableServerMixin {
///   @override
///   ServerEnv get env => ServerEnv();
///
///   @override
///   Future<void> seed() async {
///     // Initialize module data
///   }
/// }
/// ```
mixin PluggableServerMixin on PluggableModule {
  /// Gets the server environment configuration.
  ServerEnv get env;

  /// Initializes the module's data.
  ///
  /// This method is called during module initialization and should be used
  /// to set up any required data or resources.
  Future<void> seed();

  @override
  Future<PluggableModule> init() async {
    bind();
    await seed();
    return this;
  }
}