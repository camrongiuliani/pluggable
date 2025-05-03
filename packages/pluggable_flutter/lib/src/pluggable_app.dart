import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pluggable_flutter/pluggable_flutter.dart';

/// Callback type for building custom themes.
typedef ThemeBuilder = ThemeData Function(BuildContext);

/// Callback type for custom widget builders.
typedef CustomBuilder = Widget Function(BuildContext, Widget);

/// Callback type for initialization tasks.
typedef InitCallback = FutureOr<void> Function();

/// Initializes and runs a Flutter application with Pluggable framework support.
///
/// This function sets up the Pluggable framework with the specified plugins
/// and modules, then runs the Flutter application with MaterialApp.router.
///
/// Example usage:
/// ```dart
/// void main() {
///   runPluggableApp(
///     navigationPlugin: GoRouterPlug(initialRoute: '/'),
///     modules: [MyModule()],
///     storagePlugin: InMemoryStoragePlug(),
///     theme: ThemeData.light(),
///   );
/// }
/// ```
///
/// [navigationPlugin]: The navigation plugin to use (required).
/// [modules]: List of Pluggable modules to initialize.
/// [storagePlugin]: Optional storage plugin for data persistence.
/// [analyticsPlugin]: Optional analytics plugin for tracking.
/// [loggingPlugin]: Optional logging plugin for application logs.
/// [diPlugin]: Optional dependency injection plugin.
/// [theme]: Optional theme for the MaterialApp.
Future<void> runPluggableApp({
  required PluggableNavigator navigationPlugin,
  List<PluggableModule> modules = const [],
  PluggableStorage? storagePlugin,
  PluggableAnalytics? analyticsPlugin,
  PluggableLogger? loggingPlugin,
  PluggableDI? diPlugin,
  ThemeData? theme,
}) async {
  await initPluggable(
    modules: modules,
    navigationPlugin: navigationPlugin,
    storagePlugin: storagePlugin,
    analyticsPlugin: analyticsPlugin,
    loggingPlugin: loggingPlugin,
    diPlugin: diPlugin,
  );

  runApp(
    StreamBuilder(
      stream: Pluggable.stream,
      builder: (_, __) {
        return MaterialApp.router(
          theme: theme,
          routerConfig: Pluggable.navigator.config,
        );
      },
    ),
  );
}
