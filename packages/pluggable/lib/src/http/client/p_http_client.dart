// import 'dart:async';
//
// import 'package:pluggable/pluggable.dart';
//
// abstract class PluggableHttpClient {
//   /// Create the default [Dio] instance with the default implementation
//   /// based on different platforms.
//   factory PluggableHttpClient([BaseOptions? options]) => createDio(options);
//
//   /// Default Request config. More see [BaseOptions] .
//   late BaseOptions options;
//
//   /// Return the interceptors added into the instance.
//   Interceptors get interceptors;
//
//   /// The adapter that the instance is using.
//   late HttpClientAdapter httpClientAdapter;
//
//   /// [Transformer] allows changes to the request/response data before it is
//   /// sent/received to/from the server.
//   /// This is only applicable for requests that have payload.
//   late Transformer transformer;
//
//   /// Shuts down the dio client.
//   ///
//   /// If [force] is `false` (the default) the [Dio] will be kept alive
//   /// until all active connections are done. If [force] is `true` any active
//   /// connections will be closed to immediately release all resources. These
//   /// closed connections will receive an error event to indicate that the client
//   /// was shut down. In both cases trying to establish a new connection after
//   /// calling [close] will throw an exception.
//   void close({bool force = false});
//
//   /// Convenience method to make an HTTP HEAD request.
//   Future<PHttpResponse<T>> head<T>(
//     String path, {
//     Object? data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//   });
//
//   /// Convenience method to make an HTTP GET request.
//   Future<PHttpResponse<T>> get<T>(
//     String path, {
//     Object? data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//     ProgressCallback? onReceiveProgress,
//   });
//
//   /// Convenience method to make an HTTP POST request.
//   Future<PHttpResponse<T>> post<T>(
//     String path, {
//     Object? data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//     ProgressCallback? onSendProgress,
//     ProgressCallback? onReceiveProgress,
//   });
//
//   /// Convenience method to make an HTTP PUT request.
//   Future<PHttpResponse<T>> put<T>(
//     String path, {
//     Object? data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//     ProgressCallback? onSendProgress,
//     ProgressCallback? onReceiveProgress,
//   });
//
//   /// Convenience method to make an HTTP PATCH request.
//   Future<PHttpResponse<T>> patch<T>(
//     String path, {
//     Object? data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//     ProgressCallback? onSendProgress,
//     ProgressCallback? onReceiveProgress,
//   });
//
//   /// Convenience method to make an HTTP DELETE request.
//   Future<PHttpResponse<T>> delete<T>(
//     String path, {
//     Object? data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//   });
// }
