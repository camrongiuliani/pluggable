import 'dart:async';
import 'dart:io';

import 'package:pluggable_dart_server/pluggable_dart_server.dart';

/// A function type that creates a request handler for a given HTTP request.
///
/// This typedef is used to create request handlers that can process HTTP requests
/// and return appropriate responses.
typedef RequestHandler = PRequestHandler Function(
  PHttpRequest request,
);

/// An abstract base class for Dart server plugins.
///
/// This class provides the foundation for creating custom server implementations
/// that can handle HTTP requests. It includes methods for running the server
/// and handling requests.
///
/// Example usage:
/// ```dart
/// class MyServerPlug extends DartServerPlug {
///   MyServerPlug(super.ip, super.port);
///
///   @override
///   Future<HttpServer> run({
///     required InternetAddress ip,
///     required int port,
///     List<String> mounts = const ['/'],
///     String? poweredByHeader = 'Dart Pluggable',
///     SecurityContext? securityContext,
///     bool shared = false,
///   }) async {
///     // Implementation
///   }
///
///   @override
///   Future<RESPONSE> handle<REQUEST, RESPONSE>({
///     required REQUEST request,
///     required RequestHandler handler,
///   }) async {
///     // Implementation
///   }
/// }
/// ```
abstract class DartServerPlug extends Plug<DartServerPlug> {
  /// The IP address the server will listen on.
  final InternetAddress ip;

  /// The port number the server will listen on.
  final int port;

  /// Creates a new Dart server plugin.
  ///
  /// [ip]: The IP address the server will listen on.
  /// [port]: The port number the server will listen on.
  DartServerPlug(this.ip, this.port);

  /// Runs the HTTP server with the specified configuration.
  ///
  /// [ip]: The IP address to listen on.
  /// [port]: The port number to listen on.
  /// [mounts]: List of URL paths to mount the server on.
  /// [poweredByHeader]: Value for the X-Powered-By header.
  /// [securityContext]: SSL/TLS security context for HTTPS.
  /// [shared]: Whether to share the server with other isolates.
  /// Returns a [Future] that completes with the running [HttpServer].
  Future<HttpServer> run({
    required InternetAddress ip,
    required int port,
    List<String> mounts = const ['/'],
    String? poweredByHeader = 'Dart Pluggable',
    SecurityContext? securityContext,
    bool shared = false,
  });

  /// Handles an HTTP request using the provided handler.
  ///
  /// [request]: The HTTP request to handle.
  /// [handler]: The function that creates a request handler for the request.
  /// Returns a [Future] that completes with the response.
  Future<RESPONSE> handle<REQUEST, RESPONSE>({
    required REQUEST request,
    required RequestHandler handler,
  });
}
