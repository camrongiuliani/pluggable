import 'dart:async';
import 'dart:convert';

import 'package:pluggable/pluggable.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';

import '../../util/content_details.dart';
import 'dio_response_mapper.dart';
import 'exports.dart';

class DioRequestMapper extends AsyncMapper<RequestOptions, PHttpRequest> {
  DioRequestMapper(super.mapper);

  static List<Mapper> all(PluggableMapper mapper) => [
    DioRequestMapper(mapper),
    DioHttpMethodMapper(mapper),
    DioFormDataMapper(mapper),
    DioFormFileMapper(mapper),
    DioResponseMapper(mapper),
  ];

  @override
  Future<PHttpRequest> mapAsync(RequestOptions source) async {
    final data = await _resolveData(source);

    return PHttpRequest.withData(
      uri: source.uri,
      headers: source.headers.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      queryParameters: source.queryParameters,
      requestId: source.headers['x-request-id'] ?? Uuid().v4(),
      data: switch (data) {
        FormData() => mapper.map(data),
        _ => data,
      },
      method: mapper.map(source.method),
    );
  }

  Future<dynamic> _resolveData(RequestOptions source) async {
    final details = ContentDetails.fromHeaders(
      source.headers.map((key, value) => MapEntry(key, value.toString())),
    );

    final isFormUrlEncoded = details.isFormUrlEncoded;
    final isMultipartFormData = details.isMultipartFormData;

    final isJson = details.isJson;

    final isStream = details.isStream;

    return switch (isFormUrlEncoded || isMultipartFormData) {
      true => source.data as FormData,
      false => switch (isJson) {
        true => jsonDecode(source.data),
        false => switch (isStream) {
          true => (source.data as ResponseBody).stream.toFuture(),
          false => source.data,
        },
      },
    };
  }
}

extension _FutureExt on Stream<List<int>> {
  Future<List<int>> toFuture() {
    Completer<List<int>> completer = Completer();

    List<int> bytes = [];

    listen(
      (chunk) {
        bytes.addAll(chunk);
      },
      onDone: () {
        completer.complete(bytes);
      },
    );

    return completer.future;
  }
}
