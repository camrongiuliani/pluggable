import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:pluggable_dart_server/pluggable_dart_server.dart';

class FrogResponseMapper extends Mapper<PHttpResponse, Response> {
  FrogResponseMapper(super.mapper);

  @override
  Response map(PHttpResponse source) {
    return switch (source.data) {
      Stream s =>
          Response.stream(
            statusCode: source.statusCode,
            headers: source.headers,
            body: source.data,
          ),
      _ =>
          Response(
            statusCode: source.statusCode,
            headers: source.headers,
            body: switch (source.data) {
              String s => s,
              Map<String, dynamic> s => jsonEncode(s),
              _ => source.data,
            },
          ),
    };
  }
}
