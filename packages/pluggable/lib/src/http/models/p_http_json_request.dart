part of 'p_http_request.dart';

class PHttpJsonDataRequest extends PHttpRequest {
  final Map<String, dynamic> data;

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
