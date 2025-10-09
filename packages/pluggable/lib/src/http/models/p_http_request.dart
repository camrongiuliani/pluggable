/// HTTP request models for the Pluggable system.
/// 
/// This file contains the base request class and its implementations
/// for different types of HTTP requests (JSON, form data, etc.).
/// 
/// Example usage:
/// ```dart
/// final request = PHttpRequest(
///   uri: Uri.parse('https://api.example.com/data'),
///   requestId: '123',
///   method: PHttpMethod.get,
///   headers: {'Content-Type': 'application/json'},
///   queryParameters: {'page': '1'},
/// );
/// ```

import 'package:pluggable/pluggable.dart';

part 'p_http_form_data_request.dart';
part 'p_http_json_request.dart';

/// Base class for HTTP requests
sealed class _BaseRequest {
  /// The URI of the request
  final Uri uri;

  /// Unique identifier for the request
  final String requestId;

  /// The HTTP method to use
  final PHttpMethod method;

  /// Request headers
  final Map<String, Object> headers;

  /// Query parameters for the request
  final Map<String, dynamic> queryParameters;

  /// Whether to maintain a persistent connection
  final bool persistentConnection;

  /// Whether to follow redirects
  final bool followRedirects;

  /// Client IP address
  final String clientIP;

  /// Maximum number of redirects to follow
  final int? maxRedirects;

  /// Gets the path part of the URI
  String get path => uri.path;

  /// Gets the host part of the URI
  String get host => uri.host;

  /// Creates a new base request
  _BaseRequest({
    required this.uri,
    required this.requestId,
    required this.method,
    required this.headers,
    required this.queryParameters,
    this.persistentConnection = false,
    this.followRedirects = false,
    this.clientIP = '',
    this.maxRedirects,
  });
}

/// Standard HTTP request implementation
class PHttpRequest extends _BaseRequest {
  /// Creates a new HTTP request
  PHttpRequest({
    required super.uri,
    required super.requestId,
    required super.method,
    required super.headers,
    required super.queryParameters,
    super.persistentConnection,
    super.followRedirects,
    super.clientIP,
    super.maxRedirects,
  });

  /// Creates a request from JSON data
  factory PHttpRequest.fromJson(Map<String, dynamic> json) {
    return PHttpRequest(
      uri: Uri.parse(json['uri']),
      requestId: json['requestId'],
      method:
          PHttpMethod.values.firstWhere((v) => v.toString() == json['method']),
      headers: json['headers'],
      queryParameters: json['queryParameters'],
      persistentConnection: json['persistentConnection'],
      followRedirects: json['followRedirects'],
      clientIP: json['clientIP'],
      maxRedirects: json['maxRedirects'],
    );
  }

  /// Converts the request to JSON
  Map<String, dynamic> toJson() {
    return {
      'uri': uri.toString(),
      'requestId': requestId,
      'method': method.toString(),
      'headers': headers,
      'queryParameters': queryParameters,
      'persistentConnection': persistentConnection,
      'followRedirects': followRedirects,
      'clientIP': clientIP,
      'maxRedirects': maxRedirects,
    };
  }

  /// Creates a copy of this request with the specified fields replaced
  PHttpRequest copyWith({
    Uri? uri,
    String? requestId,
    PHttpMethod? method,
    Map<String, Object>? headers,
    Map<String, dynamic>? queryParameters,
    bool? persistentConnection,
    bool? followRedirects,
    String? clientIP,
    int? maxRedirects,
  }) {
    return PHttpRequest(
      uri: uri ?? this.uri,
      requestId: requestId ?? this.requestId,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      queryParameters: queryParameters ?? this.queryParameters,
      persistentConnection: persistentConnection ?? this.persistentConnection,
      followRedirects: followRedirects ?? this.followRedirects,
      clientIP: clientIP ?? this.clientIP,
      maxRedirects: maxRedirects ?? this.maxRedirects,
    );
  }

  /// Creates a request with data, automatically determining the appropriate type
  static PHttpRequest withData({
    required Uri uri,
    required String requestId,
    required PHttpMethod method,
    required Map<String, Object> headers,
    required Map<String, dynamic> queryParameters,
    required dynamic data,
    bool persistentConnection = false,
    bool followRedirects = false,
    String clientIP = '',
    int? maxRedirects,
  }) {
    final requestBase = PHttpRequest(
      uri: uri,
      requestId: requestId,
      method: method,
      headers: headers,
      queryParameters: queryParameters,
      persistentConnection: persistentConnection,
      followRedirects: followRedirects,
      clientIP: clientIP,
      maxRedirects: maxRedirects,
    );

    final fromJson = switch (data) {
      PFormData() => PHttpFormDataRequest.fromJson,
      Map<String, dynamic>() => PHttpJsonDataRequest.fromJson,
      _ => PHttpRequest.fromJson,
    };

    return fromJson({
      ...requestBase.toJson(),
      'data': switch (data) {
        PFormData() => data.toJson(),
        Map<String, dynamic>() => data,
        _ => data,
      },
    });
  }
}
