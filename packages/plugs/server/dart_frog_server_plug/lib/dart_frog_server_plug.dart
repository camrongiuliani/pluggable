import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:pluggable_dart_server/pluggable_dart_server.dart';

class DartFrogServerPlug extends DartServerPlug {
  final Handler rootHandler;

  DartFrogServerPlug({
    required this.rootHandler,
  });

  @override
  Future<DartFrogServerPlug> init() async {
    return this;
  }

  @override
  Future<HttpServer> run({
    // required Handler handler,
    required InternetAddress ip,
    required int port,
    List<String> mounts = const ['/'],
    String? poweredByHeader = 'Dart Pluggable',
    SecurityContext? securityContext,
    bool shared = false,
  }) {
    final router = Router();

    for (final path in mounts) {
      router.mount(
        path,
        rootHandler,
      );
    }

    return serve(
      router,
      ip,
      port,
      shared: true,
    );
  }

  @override
  Future<RESPONSE> handle<REQUEST, RESPONSE>({
    required REQUEST request,
    required RequestHandler handler,
  }) {
    // TODO: implement handle
    throw UnimplementedError();
  }
}
