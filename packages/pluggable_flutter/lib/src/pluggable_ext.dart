import 'package:flutter/widgets.dart';
import 'package:pluggable_flutter/pluggable_flutter.dart';
import 'package:pluggable/pluggable.dart' as core;
import 'package:collection/collection.dart';

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
        .map(
          (m) => m as PluggableFlutterModule,
        )
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

extension PluggableFlutter on PluggableImpl {
  BuildContext get rootContext => navigator.context;

  PluggableNavigator get navigator => get();

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
        if (module != newModule) {
          module.unbind();
        }
      }
    }
  }

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

mixin PluggableFlutterModule on PluggableModule {
  List<PluggableRouteBase> buildRoutes();
}
