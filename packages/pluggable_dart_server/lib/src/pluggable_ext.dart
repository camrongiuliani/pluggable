import 'dart:async';

import 'package:pluggable/pluggable.dart' as core;
import 'package:pluggable_dart_server/pluggable_dart_server.dart';


Future<core.PluggableImpl> initPluggable({
  required DartServerPlug server,
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

  await pluggable.plugin<DartServerPlug>(server);

  return pluggable;
}

extension PluggableDartServer on PluggableImpl {
  DartServerPlug get server => get();
}

mixin PluggableServerMixin on PluggableModule {
  ServerEnv get env;
}