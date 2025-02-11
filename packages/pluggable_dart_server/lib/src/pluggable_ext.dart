import 'dart:async';
import 'dart:io';

import 'package:pluggable/pluggable.dart' as core;
import 'package:pluggable_dart_server/pluggable_dart_server.dart';


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
  await initPluggable(
    modules: modules,
    storagePlugin: storagePlugin,
    analyticsPlugin: analyticsPlugin,
    loggingPlugin: loggingPlugin,
    diPlugin: diPlugin,
    server: server,
  );

  return Pluggable.server.run(
    ip: server.ip,
    port: server.port,
    mounts: mounts.where((s) => s.isNotEmpty).toList(),
    poweredByHeader: poweredByHeader,
    securityContext: securityContext,
    shared: shared,
  );
}

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

extension PluggableDartServer on PluggableImpl {
  DartServerPlug get server => get();
}

mixin PluggableServerMixin on PluggableModule {
  ServerEnv get env;

  Future<void> seed();

  @override
  Future<PluggableModule> init() async {
    bind();
    await seed();
    return this;
  }
}