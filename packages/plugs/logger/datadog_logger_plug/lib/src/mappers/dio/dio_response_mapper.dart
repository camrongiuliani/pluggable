import 'dart:async';
import 'dart:convert';

import 'package:pluggable/pluggable.dart';
import 'package:dio/dio.dart';

import '../../util/content_details.dart';

extension HXT on Headers {
  Map<String, String> toMap() {
    return map.map((key, value) => MapEntry(key, value.firstOrNull ?? ''));
  }
}

class DioResponseMapper extends AsyncMapper<Response, PHttpResponse> {
  DioResponseMapper(super.mapper);

  @override
  Future<PHttpResponse> mapAsync(Response response) async {
    final data = await _resolveData(response);

    return PHttpResponse(
      headers: response.headers.toMap(),
      statusCode: response.statusCode ?? 0,
      message: response.statusMessage ?? '',
      data: data,
    );
  }

  FutureOr<dynamic> _resolveData(Response response) {
    final details = ContentDetails.fromHeaders(
      response.headers.toMap(),
    );

    final isFormUrlEncoded = details.isFormUrlEncoded;
    final isMultipartFormData = details.isMultipartFormData;

    final isJson = details.isJson;

    final isStream = details.isStream;

    return switch (isFormUrlEncoded || isMultipartFormData) {
      true => response.data as FormData,
      false => switch (isJson) {
        true => switch (response.data) {
          Map m => m,
          String s => jsonDecode(s) as Map<String, dynamic>,
          _ => response.data,
        },
        false => switch (isStream) {
          true => (response.data as ResponseBody).stream.toFuture(),
          false => response.data,
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
