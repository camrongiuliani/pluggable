import 'dart:async';
import 'dart:io';

import 'package:pluggable_dart_server/pluggable_dart_server.dart';

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
  final HeaderValidator? headerValidator;

  /// Response headers to be set in the response.
  final Map<String, Object> _responseHeaders = {};

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
    Pluggable.logger.v(
      '$runtimeType created [${request.method.value}]',
      tag: '$runtimeType',
      traceId: request.requestId,
    );
  }

  /// Adds a response header to the handler.
  void addResponseHeader(
    String key,
    Object value,
  ) {
    _responseHeaders[key] = value;
  }

  /// Removes a response header from the handler.
  void removeResponseHeader(String key) {
    _responseHeaders.remove(key);
  }

  /// Clears all response headers.
  void clearResponseHeaders() {
    _responseHeaders.clear();
  }

  /// Gets the current response headers.
  Map<String, Object> get responseHeaders => _responseHeaders;

  /// Overrides the response `Content-Type` for this handler.
  ///
  /// This is a convenience around [addResponseHeader] for the common case of
  /// just wanting to use a non-default content type while keeping the
  /// standard `{ "requestId": ..., "data": ... }` body wrapping. For full
  /// control over the response body, return a [PRawResponse] from your
  /// handler method instead.
  void setContentType(ContentType contentType) {
    _responseHeaders[HttpHeaders.contentTypeHeader] = contentType.value;
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
      // If the handler returned a fully custom response, pass it through
      // verbatim — no body wrapping, no content-type auto-detection.
      if (response.data is PRawResponse) {
        return _buildRawResponse(response.data as PRawResponse);
      }

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
          'x-request-id': request.requestId,
          HttpHeaders.contentTypeHeader: switch (isJson) {
            true => ContentType.json.mimeType,
            _ =>
            switch (data) {
              Stream() => ContentType.binary.mimeType,
              _ => ContentType.text.mimeType,
            },
          },
          ..._responseHeaders,
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

  /// Builds a [PHttpResponse] from a [PRawResponse] returned by a handler.
  ///
  /// Headers are layered in this precedence (later overrides earlier):
  /// 1. `x-request-id` (when [PRawResponse.includeRequestId] is true).
  /// 2. Auto-applied `Content-Type` (when [PRawResponse.contentType] is set).
  /// 3. Headers added on the handler via [addResponseHeader].
  /// 4. Headers supplied directly on the [PRawResponse].
  PHttpResponse _buildRawResponse(PRawResponse raw) {
    final headers = <String, Object>{
      if (raw.includeRequestId) 'x-request-id': request.requestId,
      if (raw.contentType != null)
        HttpHeaders.contentTypeHeader: raw.contentType!.value,
      ..._responseHeaders,
      ...raw.headers,
    };

    return PHttpResponse(
      statusCode: raw.statusCode,
      headers: headers,
      data: raw.body,
      message: 'message',
    );
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
      httpMethod: request.method,
      headers: request.headers,
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
