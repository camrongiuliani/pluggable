import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_server_plug/mappers/request_mapper.dart';
import 'package:dart_frog_server_plug/mappers/response_mapper.dart';
import 'package:pluggable_dart_server/pluggable_dart_server.dart';
import 'package:uuid/uuid.dart';

class DartFrogServerPlug extends DartServerPlug {
  final Handler rootHandler;

  DartFrogServerPlug({
    required this.rootHandler,
    required InternetAddress internetAddress,
    required int port,
  }) : super(internetAddress, port);

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
      router.call,
      ip,
      port,
      shared: true,
      poweredByHeader: poweredByHeader,
    );
  }

  @override
  Future<RES> handle<REQUEST, RES>({
    required REQUEST request,
    required RequestHandler handler,
  }) async {
    final context = request as RequestContext;

    final req = await Pluggable.mapper.mapAsync<RequestContext, PHttpRequest>(
      context,
    );

    final result = await handler(req).execute();

    final mapped = Pluggable.mapper.map<PHttpResponse, Response>(
      result,
    );

    return mapped.copyWith(
      headers: {
        'x-request-id': req.requestId,
        ...mapped.headers,
      },
    ) as RES;
  }
}
