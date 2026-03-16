part of 'p_http_request.dart';

/// A specialized HTTP request class for handling binary data payloads.
///
/// This class extends [PHttpRequest] and is specifically designed for requests
/// that send binary data (List<int>) in their body.
///
/// Example usage:
/// ```dart
/// final request = PHttpBytesDataRequest(
///   uri: Uri.parse('https://api.example.com/upload'),
///   requestId: 'req-123',
///   method: PHttpMethod.post,
///   headers: {'Content-Type': 'application/octet-stream'},
///   queryParameters: {},
///   data: [0x00, 0x01, 0x02],
/// );
/// ```
class PHttpBytesDataRequest extends PHttpRequest {
  /// The binary data to be sent in the request body.
  final List<int> data;

  /// Creates a new binary data HTTP request.
  PHttpBytesDataRequest({
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

  /// Creates a [PHttpBytesDataRequest] from a JSON map.
  factory PHttpBytesDataRequest.fromJson(Map<String, dynamic> json) {
    return PHttpBytesDataRequest(
      uri: Uri.parse(json['uri']),
      requestId: json['requestId'],
      method:
          PHttpMethod.values.firstWhere((v) => v.toString() == json['method']),
      headers: json['headers'],
      queryParameters: json['queryParameters'],
      data: List<int>.from(json['data']),
      persistentConnection: json['persistentConnection'],
      followRedirects: json['followRedirects'],
      clientIP: json['clientIP'],
      maxRedirects: json['maxRedirects'],
    );
  }

  /// Converts this request to a JSON map.
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
  @override
  PHttpBytesDataRequest copyWith({
    Uri? uri,
    String? requestId,
    PHttpMethod? method,
    Map<String, Object>? headers,
    Map<String, dynamic>? queryParameters,
    List<int>? data,
    bool? persistentConnection,
    bool? followRedirects,
    String? clientIP,
    int? maxRedirects,
  }) {
    return PHttpBytesDataRequest(
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
