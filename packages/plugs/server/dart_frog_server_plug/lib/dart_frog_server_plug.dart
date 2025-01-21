import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_server_plug/mappers/request_mapper.dart';
import 'package:dart_frog_server_plug/mappers/response_mapper.dart';
import 'package:pluggable_dart_server/pluggable_dart_server.dart';

class DartFrogServerPlug extends DartServerPlug {
  final Handler rootHandler;

  DartFrogServerPlug({
    required this.rootHandler,
  });

  @override
  Future<DartFrogServerPlug> init() async {

    Pluggable.mapper.buildAtlas([
      ...FrogRequestMapper.all(Pluggable.mapper),
      FrogResponseMapper(Pluggable.mapper),
    ]);

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
  Future<RES> handle<REQUEST, RES>({
    required REQUEST request,
    required RequestHandler handler,
  }) async {
    final result = await handler(
      await Pluggable.mapper.mapAsync<RequestContext, PHttpRequest>(
        request as RequestContext,
      ),
    ).execute();

    return Pluggable.mapper.map<PHttpResponse, Response>(
      result,
    ) as RES;
  }
}
