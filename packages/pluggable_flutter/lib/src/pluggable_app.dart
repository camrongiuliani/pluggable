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
  FutureOr<void> Function()? initCallback,
  ThemeData Function(BuildContext context)? themeBuilder,
  Widget Function(BuildContext context, Widget child)? builder,
}) async {
  await initPluggable(
    modules: modules,
    navigationPlugin: navigationPlugin,
    storagePlugin: storagePlugin,
    analyticsPlugin: analyticsPlugin,
    loggingPlugin: loggingPlugin,
    diPlugin: diPlugin,
  );

  await initCallback?.call();

  runApp(
    StreamBuilder(
      stream: Pluggable.stream,
      builder: (ctx, __) {
        if (builder != null) {
          return builder(
            ctx,
            MaterialApp.router(
              theme: themeBuilder?.call(ctx),
              routerConfig: Pluggable.navigator.config,
            ),
          );
        }

        return MaterialApp.router(
          theme: themeBuilder?.call(ctx),
          routerConfig: Pluggable.navigator.config,
        );
      },
    ),
  );
}
