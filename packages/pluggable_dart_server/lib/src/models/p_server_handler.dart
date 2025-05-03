import 'dart:async';

import 'package:pluggable_dart_server/pluggable_dart_server.dart';

/// A type definition for server request handlers.
///
/// This type represents a function that handles HTTP requests and returns
/// HTTP responses. It is used throughout the server implementation to define
/// request processing logic.
///
/// The handler function:
/// - Takes a [PHttpRequest] as input
/// - Returns a [FutureOr<PHttpResponse<T>>] where T is the response data type
/// - Can be either synchronous or asynchronous
///
/// Example usage:
/// ```dart
/// PServerHandler handler = (request) {
///   return PHttpResponse(
///     statusCode: PHttpStatusCode.ok,
///     data: {'message': 'Hello, World!'},
///   );
/// };
/// ```
typedef PServerHandler = FutureOr<PHttpResponse<T>> Function<T>(
  PHttpRequest request,
);
