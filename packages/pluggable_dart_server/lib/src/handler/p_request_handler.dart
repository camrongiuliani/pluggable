import 'dart:async';

import 'package:pluggable_dart_server/pluggable_dart_server.dart';
import 'dart:io';

/// A base class for handling HTTP requests in the Pluggable server.
///
/// This class provides a foundation for implementing HTTP request handlers
/// with built-in validation, error handling, and response formatting.
/// It supports all standard HTTP methods and automatically handles
/// serialization of response data.
///
/// Example usage:
/// ```dart
/// class MyRequestHandler extends PRequestHandler {
///   MyRequestHandler(super.request);
///
///   @override
///   FutureOr<Object?> get() async {
///     return {'message': 'Hello, World!'};
///   }
/// }
/// ```
class PRequestHandler {
  /// The HTTP request being handled.
  final PHttpRequest request;

  /// List of exceptions that occurred during request handling.
  final List<PHttpException> exceptions = [];

  /// Optional validator for query parameters.
  final QueryParamValidator? queryValidator;

  /// Optional validator for request headers.
  final HeaderValidation? headerValidator;

  /// Creates a new request handler.
  ///
  /// [request]: The HTTP request to handle.
  /// [queryValidator]: Optional validator for query parameters.
  /// [headerValidator]: Optional validator for request headers.
  PRequestHandler({
    required this.request,
    this.queryValidator,
    this.headerValidator,
  }) {
    Pluggable.logger.header(
      '$runtimeType created [${request.method.value}] for ${request.requestId}',
      tag: '$runtimeType',
    );
    Pluggable.logger.v(
      'Query Parameters ${request.queryParameters}',
      showPrefix: true,
      tag: '$runtimeType',
    );

    final data = switch (request) {
      PHttpFormDataRequest r => r.data,
      PHttpJsonDataRequest r => r.data,
      _ => null,
    };

    Pluggable.logger.v(
      'Request Body: $data',
      showPrefix: true,
      tag: '$runtimeType',
    );
  }

  /// Checks if the given data is a primitive Dart type.
  ///
  /// Primitive types include:
  /// - Numbers (int, double)
  /// - Strings
  /// - Booleans
  /// - Null
  /// - Lists and Maps containing only primitive types
  bool isPrimitiveDartType(dynamic data) {
    if (data is num || data is String || data is bool || data == null) {
      return true;
    } else if (data is List) {
      return data.every((element) => isPrimitiveDartType(element));
    } else if (data is Map) {
      return data.values.every((element) => isPrimitiveDartType(element));
    }
    return false;
  }

  /// Executes the request handler and returns a formatted response.
  ///
  /// This method:
  /// 1. Calls the appropriate HTTP method handler
  /// 2. Formats the response data
  /// 3. Sets appropriate content type headers
  /// 4. Handles any errors that occur
  FutureOr<PHttpResponse> execute() async {
    return _execute().then((response) {
      final data = switch (isPrimitiveDartType(response.data)) {
        true => response.data,
        false =>
        switch (response.data) {
          Stream() => response.data,
          _ => (response.data as Object?).serialized,
        },
      };

      bool isJson = switch (data) {
        List l => l.every(isPrimitiveDartType),
        Map m => m.values.every(isPrimitiveDartType),
        _ => false,
      };

      return response.copyWith(
        statusCode: 200,
        data: switch (isPrimitiveDartType(data)) {
          true =>
          {
            'requestId': request.requestId,
            'data': data,
          },
          false => data,
        },
        headers: {
          HttpHeaders.contentTypeHeader: switch (isJson) {
            true => ContentType.json.mimeType,
            _ =>
            switch (data) {
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
          PHttpException e =>
          {
            ...e.toJson(),
            'stackTrace': trace,
          },
          _ =>
          {
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

  /// Internal method that executes the request and returns a response.
  ///
  /// This method:
  /// 1. Validates query parameters and headers
  /// 2. Calls the appropriate HTTP method handler
  /// 3. Returns a basic response
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

  /// Handles error responses.
  FutureOr<void> error() async {}

  /// Handles HTTP DELETE requests.
  ///
  /// Override this method to implement DELETE request handling.
  FutureOr<Object?> delete() {
    throw UnimplementedError(
      '${request.path} does not implement DELETE',
    );
  }

  /// Handles HTTP GET requests.
  ///
  /// Override this method to implement GET request handling.
  FutureOr<Object?> get() async {
    throw UnimplementedError(
      '${request.path} does not implement GET',
    );
  }

  /// Handles HTTP HEAD requests.
  ///
  /// Override this method to implement HEAD request handling.
  FutureOr<Object?> head() {
    throw UnimplementedError(
      '${request.path} does not implement HEAD',
    );
  }

  /// Handles HTTP OPTIONS requests.
  ///
  /// Override this method to implement OPTIONS request handling.
  FutureOr<Object?> options() {
    throw UnimplementedError(
      '${request.path} does not implement OPTIONS',
    );
  }

  /// Handles HTTP PATCH requests.
  ///
  /// Override this method to implement PATCH request handling.
  FutureOr<Object?> patch() {
    throw UnimplementedError(
      '${request.path} does not implement PATCH',
    );
  }

  /// Handles HTTP POST requests.
  ///
  /// Override this method to implement POST request handling.
  FutureOr<Object?> post() {
    throw UnimplementedError(
      '${request.path} does not implement POST',
    );
  }

  /// Handles HTTP PUT requests.
  ///
  /// Override this method to implement PUT request handling.
  FutureOr<Object?> put() {
    throw UnimplementedError(
      '${request.path} does not implement PUT',
    );
  }
}

/// Extension on [Object?] to provide serialization capabilities.
extension on Object? {
  /// Serializes an object to a format suitable for JSON encoding.
  ///
  /// This method handles:
  /// - Lists (recursively serializes elements)
  /// - Maps (recursively serializes values)
  /// - Primitive types (returns as-is)
  /// - Objects with toJson() method (calls toJson())
  /// - Streams (returns as-is)
  dynamic get serialized {
    dynamic obj = this;

    try {
      return switch (obj) {
        List l => l.map((e) => (e as Object?).serialized).toList(),
        Map m => m.map((k, v) => MapEntry(k, (v as Object?).serialized)),
        String() || num() || bool() || Stream() || null => obj,
        _ => obj.toJson(),
      };
    } catch (_) {
      return {};
    }
  }
}
