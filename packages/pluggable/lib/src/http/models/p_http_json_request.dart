part of 'p_http_request.dart';

/// A specialized HTTP request class for handling JSON data payloads.
///
/// This class extends [PHttpRequest] and is specifically designed for requests
/// that send JSON data in their body. It provides methods for JSON serialization
/// and deserialization, as well as a convenient way to create modified copies
/// of the request.
///
/// Example usage:
/// ```dart
/// final request = PHttpJsonDataRequest(
///   uri: Uri.parse('https://api.example.com/data'),
///   requestId: 'req-123',
///   method: PHttpMethod.post,
///   headers: {'Content-Type': 'application/json'},
///   queryParameters: {'page': '1'},
///   data: {'name': 'John', 'age': 30},
/// );
/// ```
class PHttpJsonDataRequest extends PHttpRequest {
  /// The JSON data to be sent in the request body.
  final Map<String, dynamic> data;

  /// Creates a new JSON data HTTP request.
  ///
  /// [uri]: The target URI for the request.
  /// [requestId]: A unique identifier for the request.
  /// [method]: The HTTP method to use.
  /// [headers]: HTTP headers to include in the request.
  /// [queryParameters]: Query parameters to append to the URI.
  /// [data]: The JSON data to send in the request body.
  /// [persistentConnection]: Whether to maintain a persistent connection.
  /// [followRedirects]: Whether to automatically follow redirects.
  /// [clientIP]: The client's IP address.
  /// [maxRedirects]: Maximum number of redirects to follow.
  PHttpJsonDataRequest({
    required super.uri,
    required super.requestId,
    required super.method,
    required super.headers,
    required super.queryParameters,
    required this.data,
    super.persistentConnection,
    super.followRedirects,
    super.clientIP,
    super.maxRedirects,
  });

  /// Creates a [PHttpJsonDataRequest] from a JSON map.
  ///
  /// This factory constructor is used to deserialize a JSON map into a
  /// [PHttpJsonDataRequest] instance. It handles the conversion of string
  /// representations back into their proper types.
  ///
  /// [json]: A map containing the JSON data.
  factory PHttpJsonDataRequest.fromJson(Map<String, dynamic> json) {
    return PHttpJsonDataRequest(
      uri: Uri.parse(json['uri']),
      requestId: json['requestId'],
      method:
          PHttpMethod.values.firstWhere((v) => v.toString() == json['method']),
      headers: json['headers'],
      queryParameters: json['queryParameters'],
      data: json['data'],
      persistentConnection: json['persistentConnection'],
      followRedirects: json['followRedirects'],
      clientIP: json['clientIP'],
      maxRedirects: json['maxRedirects'],
    );
  }

  /// Converts this request to a JSON map.
  ///
  /// This method serializes the request into a format that can be easily
  /// converted to JSON. It handles the conversion of complex types like
  /// [Uri] and [PHttpMethod] into their string representations.
  @override
  Map<String, dynamic> toJson() {
    return {
      'uri': uri.toString(),
      'requestId': requestId,
      'method': method.toString(),
      'headers': headers,
      'queryParameters': queryParameters,
      'data': data,
      'persistentConnection': persistentConnection,
      'followRedirects': followRedirects,
      'clientIP': clientIP,
      'maxRedirects': maxRedirects,
    };
  }

  /// Creates a copy of this request with the given fields replaced with the new values.
  ///
  /// This method returns a new [PHttpJsonDataRequest] instance with the specified
  /// fields updated. Fields not specified in the parameters will retain their
  /// original values.
  ///
  /// Example:
  /// ```dart
  /// final updatedRequest = request.copyWith(
  ///   data: {'name': 'Jane', 'age': 25},
  ///   headers: {'Authorization': 'Bearer token'},
  /// );
  /// ```
  @override
  PHttpJsonDataRequest copyWith({
    Uri? uri,
    String? requestId,
    PHttpMethod? method,
    Map<String, Object>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    bool? persistentConnection,
    bool? followRedirects,
    String? clientIP,
    int? maxRedirects,
  }) {
    return PHttpJsonDataRequest(
      uri: uri ?? this.uri,
      requestId: requestId ?? this.requestId,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      queryParameters: queryParameters ?? this.queryParameters,
      data: data ?? this.data,
      persistentConnection: persistentConnection ?? this.persistentConnection,
      followRedirects: followRedirects ?? this.followRedirects,
      clientIP: clientIP ?? this.clientIP,
      maxRedirects: maxRedirects ?? this.maxRedirects,
    );
  }
}
