import 'dart:async';
import 'dart:io';

import 'package:pluggable_dart_server/pluggable_dart_server.dart';

typedef RequestHandler = PRequestHandler Function(
  PHttpRequest request,
);

abstract class DartServerPlug extends Plug<DartServerPlug> {
  final InternetAddress ip;
  final int port;

  DartServerPlug(this.ip, this.port);

  Future<HttpServer> run({
    // required PServerHandler handler,
    required InternetAddress ip,
    required int port,
    List<String> mounts = const ['/'],
    String? poweredByHeader = 'Dart Pluggable',
    SecurityContext? securityContext,
    bool shared = false,
  });

  Future<RESPONSE> handle<REQUEST, RESPONSE>({
    required REQUEST request,
    required RequestHandler handler,
  });
}
