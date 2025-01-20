import 'dart:async';

import 'package:pluggable_dart_server/pluggable_dart_server.dart';
import 'package:pluggable_dart_server/src/handler/exceptions.dart';

class PRequestHandler {
  final PHttpRequest request;
  final List<ApiException> exceptions = [];
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
    Pluggable.logger.v(
      'Request Body ${request.data}',
      showPrefix: true,
    );
  }

  FutureOr<Object?> execute() async {
    try {
      return await _execute();
    } catch (e) {
      await error();
      rethrow;
    }
  }

  FutureOr<Object?> _execute() async {
    if (request.data is Future) {
      await request.data;
    }

    queryValidator?.validate(
      httpMethod: request.method,
      parameters: request.queryParameters,
    );

    headerValidator?.validate(
      request.headers,
    );

    return switch (request.method) {
      PHttpMethod.delete => delete(),
      PHttpMethod.get => get(),
      PHttpMethod.head => head(),
      PHttpMethod.options => options(),
      PHttpMethod.patch => patch(),
      PHttpMethod.post => post(),
      PHttpMethod.put => put(),
    };
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
