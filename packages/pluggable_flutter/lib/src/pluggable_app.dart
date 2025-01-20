import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pluggable_flutter/pluggable_flutter.dart';

typedef ThemeBuilder = ThemeData Function(BuildContext);
typedef CustomBuilder = Widget Function(BuildContext, Widget);
typedef InitCallback = FutureOr<void> Function();

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
    AnimatedBuilder(
      animation: Pluggable,
      builder: (_, __) {
        return MaterialApp.router(
          theme: theme,
          routerConfig: Pluggable.navigator.config,
        );
      },
    ),
  );
}
