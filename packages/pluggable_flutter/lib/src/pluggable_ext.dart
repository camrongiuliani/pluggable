import 'package:flutter/widgets.dart';
import 'package:pluggable_flutter/pluggable_flutter.dart';
import 'package:pluggable/pluggable.dart' as core;
import 'package:collection/collection.dart';

/// Initializes the Pluggable framework with Flutter-specific configuration.
///
/// This function sets up the Pluggable framework with the specified plugins
/// and modules, and configures route handling for Flutter applications.
///
/// Example usage:
/// ```dart
/// final pluggable = await initPluggable(
///   navigationPlugin: GoRouterPlug(initialRoute: '/'),
///   modules: [MyModule()],
///   storagePlugin: InMemoryStoragePlug(),
/// );
/// ```
///
/// [navigationPlugin]: The navigation plugin to use (required).
/// [modules]: List of Pluggable modules to initialize.
/// [storagePlugin]: Optional storage plugin for data persistence.
/// [analyticsPlugin]: Optional analytics plugin for tracking.
/// [loggingPlugin]: Optional logging plugin for application logs.
/// [diPlugin]: Optional dependency injection plugin.
Future<PluggableImpl> initPluggable({
  required PluggableNavigator navigationPlugin,
  List<PluggableModule> modules = const [],
  PluggableStorage? storagePlugin,
  PluggableAnalytics? analyticsPlugin,
  PluggableLogger? loggingPlugin,
  PluggableDI? diPlugin,
}) async {
  final pluggable = await core.initPluggable(
    modules: modules,
    storagePlugin: storagePlugin,
    analyticsPlugin: analyticsPlugin,
    loggingPlugin: loggingPlugin,
    diPlugin: diPlugin,
  );

  await pluggable.plugin<PluggableNavigator>(navigationPlugin);

  await pluggable.navigator.updateRoutes(
    pluggable.modules
        .whereType<PluggableFlutterModule>()
        .map(
          (m) => m.buildRoutes(),
        )
        .flattened,
  );

  pluggable.navigator.addListener(
    pluggable._handleModuleBinding,
  );

  return pluggable;
}

/// Flutter-specific extensions for the Pluggable framework.
extension PluggableFlutter on PluggableImpl {
  /// Gets the root build context of the application.
  BuildContext get rootContext => navigator.context;

  /// Gets the navigation plugin instance.
  PluggableNavigator get navigator => get();

  /// Handles module binding based on the current route.
  ///
  /// This method is called when the route changes to ensure that
  /// the appropriate module is bound and others are unbound.
  Future<void> _handleModuleBinding() async {
    final route = navigator.routerDelegate.currentConfiguration.uri.path;

    if (route.isEmpty) {
      return;
    }

    final PluggableModule newModule = _determineRouteModule(
      navigator.routerDelegate.currentConfiguration.uri.path,
    );

    if (!newModule.bound) {
      newModule.bind();

      for (final module in modules) {
        if (module != newModule && module is! PluggableFlutterModule) {
          module.unbind();
        }
      }
    }
  }

  /// Determines which module should handle the current route.
  ///
  /// This method recursively checks the route hierarchy to find
  /// the module that should handle the current route.
  PluggableModule _determineRouteModule(String route) {
    bool recursiveCheck(PluggableRouteBase base) {
      return switch (base) {
        final PluggableRoute r =>
          r.path == route || r.routes.any(recursiveCheck),
        final PluggableShellRoute r => r.routes.any(recursiveCheck),
        _ => throw Exception('Unsupported route type in recursive check'),
      };
    }

    final matches = modules.where((module) {
      return (module as PluggableFlutterModule).buildRoutes().any(
            (r) => recursiveCheck(r),
          );
    }).toList();

    assert(
      matches.length == 1,
      'Multiple or Zero modules found containing route: $route',
    );

    return matches.first;
  }
}

/// Mixin for Flutter-specific Pluggable modules.
///
/// This mixin provides route building capabilities for Flutter modules.
mixin PluggableFlutterModule on PluggableModule {
  /// Builds the routes for this module.
  ///
  /// This method should return a list of routes that this module handles.
  List<PluggableRouteBase> buildRoutes();
}
