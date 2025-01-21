import 'dart:async';

import 'package:pluggable_dart_server/pluggable_dart_server.dart';
import 'dart:io';

class PRequestHandler {
  final PHttpRequest request;
  final List<PHttpException> exceptions = [];
  final QueryParamValidator? queryValidator;
  final HeaderValidation? headerValidator;

  PRequestHandler({
    required this.request,
    this.queryValidator,
    this.headerValidator,
  }) {
    Pluggable.logger.header(
      '$runtimeType created [${request.method.value}] for ${request.requestId}',
    );
    Pluggable.logger.v(
      'Query Parameters ${request.queryParameters}',
      showPrefix: true,
    );

    final data = switch (request) {
      PHttpFormDataRequest r => r.data,
      PHttpJsonDataRequest r => r.data,
      _ => null,
    };

    Pluggable.logger.v(
      'Request Body: $data',
      showPrefix: true,
    );
  }

  // Checks to see if the [data] is a primitive Dart type.
  // Lists and maps are also primitive if they contain only primitive types.
  bool isPrimitiveDartType(dynamic data) {
    if (data is num || data is String || data is bool) {
      return true;
    } else if (data is List) {
      return data.every((element) => isPrimitiveDartType(element));
    } else if (data is Map) {
      return data.values.every((element) => isPrimitiveDartType(element));
    }
    return false;
  }

  FutureOr<PHttpResponse> execute() async {
    return _execute().then((response) {
      final data = switch (isPrimitiveDartType(response.data)) {
        true => response.data,
        false => switch (response.data) {
          Stream() => response.data,
          _ => (response.data as Object?).serialized,
        },
      };

      bool isJson = switch (data) {
        Map<String, dynamic>() || List<Map<String, dynamic>>() => true,
        _ => false,
      };

      return response.copyWith(
        statusCode: 200,
        data: switch (isPrimitiveDartType(data)) {
          true => {
              'requestId': request.requestId,
              'data': data,
          },
          false => data,
        },
        headers: {
          HttpHeaders.contentTypeHeader: switch (isJson) {
            true => ContentType.json.mimeType,
            _ => switch (data) {
                Stream() => ContentType.binary.mimeType,
                _ => ContentType.text.mimeType,
              },
          },
        },
      );
    }).onError((error, stackTrace) {
      final trace = stackTrace.toString().split('\n').where(
        (e) {
          return e != '<asynchronous suspension>';
        },
      ).toList();

      return PHttpResponse(
        statusCode: switch (error) {
          PHttpException e => e.statusCode,
          _ => 500,
        },
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
        data: switch (error) {
          PHttpException e => {
              ...e.toJson(),
              'stackTrace': trace,
            },
          _ => {
              'error': error.toString(),
              'stackTrace': trace,
            },
        },
        message: switch (error) {
          PHttpException e => e.message,
          _ => 'Internal Server Error',
        },
      );
    });
  }

  Future<PHttpResponse> _execute() async {
    queryValidator?.validate(
      httpMethod: request.method,
      parameters: request.queryParameters,
    );

    headerValidator?.validate(
      request.headers,
    );

    return PHttpResponse(
      headers: {},
      statusCode: 200,
      data: await switch (request.method) {
        PHttpMethod.delete => delete(),
        PHttpMethod.get => get(),
        PHttpMethod.head => head(),
        PHttpMethod.options => options(),
        PHttpMethod.patch => patch(),
        PHttpMethod.post => post(),
        PHttpMethod.put => put(),
      },
      message: 'message',
    );
  }

  FutureOr<void> error() async {}

  FutureOr<Object?> delete() {
    throw UnimplementedError(
      '${request.path} does not implement DELETE',
    );
  }

  FutureOr<Object?> get() async {
    throw UnimplementedError(
      '${request.path} does not implement GET',
    );
  }

  FutureOr<Object?> head() {
    throw UnimplementedError(
      '${request.path} does not implement HEAD',
    );
  }

  FutureOr<Object?> options() {
    throw UnimplementedError(
      '${request.path} does not implement OPTIONS',
    );
  }

  FutureOr<Object?> patch() {
    throw UnimplementedError(
      '${request.path} does not implement PATCH',
    );
  }

  FutureOr<Object?> post() {
    throw UnimplementedError(
      '${request.path} does not implement POST',
    );
  }

  FutureOr<Object?> put() {
    throw UnimplementedError(
      '${request.path} does not implement PUT',
    );
  }
}

extension on Object? {
  dynamic get serialized {
    dynamic obj = this;

    try {
      return switch (obj) {
        List l => l.map((e) => (e as Object?).serialized).toList(),
        _ => obj.toJson(),
      };
    } catch (_) {
      return {};
    }
  }
}
