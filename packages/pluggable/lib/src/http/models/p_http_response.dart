/// HTTP response model for the Pluggable system.
/// 
/// This class represents a generic HTTP response with typed data.
/// It includes headers, status code, response data, and a message.
/// 
/// Example usage:
/// ```dart
/// final response = PHttpResponse<String>(
///   headers: {'Content-Type': 'text/plain'},
///   statusCode: 200,
///   data: 'Hello, World!',
///   message: 'Success',
/// );
/// ```

/// Generic HTTP response class
class PHttpResponse<T> {
  /// Response headers
  final Map<String, Object> headers;

  /// HTTP status code
  final int statusCode;

  /// Response data of type T
  final T? data;

  /// Response message
  final String message;

  /// Private constructor for internal use
  PHttpResponse._(
    this.headers,
    this.statusCode,
    this.data,
    this.message,
  );

  /// Creates a new HTTP response
  factory PHttpResponse({
    required Map<String, Object> headers,
    required int statusCode,
    required T? data,
    required String message,
  }) {
    return PHttpResponse._(
      headers,
      statusCode,
      data,
      message,
    );
  }

  /// Converts the response to JSON
  Map<String, dynamic> toJson() {
    return {
      'headers': headers,
      'statusCode': statusCode,
      'data': data,
      'message': message,
    };
  }

  /// Creates a response from JSON data
  factory PHttpResponse.fromJson(Map<String, dynamic> json) {
    return PHttpResponse(
      headers: json['headers'],
      statusCode: json['statusCode'],
      data: json['data'],
      message: json['message'],
    );
  }

  /// Creates a copy of this response with the specified fields replaced
  PHttpResponse copyWith({
    Map<String, Object>? headers,
    int? statusCode,
    T? data,
    String? message,
  }) {
    return PHttpResponse(
      headers: headers ?? this.headers,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
