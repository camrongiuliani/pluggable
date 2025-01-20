import 'package:pluggable/pluggable.dart';

class PHttpRequest {
  final Uri uri;
  final String requestId;
  final PHttpMethod method;
  final dynamic data;
  final Map<String, Object> headers;
  final Map<String, dynamic> queryParameters;
  final bool persistentConnection;
  final bool followRedirects;
  final String clientIP;
  final int? maxRedirects;

  String get path => uri.path;

  String get host => uri.host;

  PHttpRequest._(
    this.uri,
    this.requestId,
    this.method,
    this.data,
    this.headers,
    this.queryParameters,
    this.persistentConnection,
    this.followRedirects,
    this.clientIP,
    this.maxRedirects,
  );

  factory PHttpRequest({
    required Uri uri,
    required String requestId,
    required PHttpMethod method,
    dynamic data,
    Map<String, Object> headers = const {},
    Map<String, dynamic> queryParameters = const {},
    bool persistentConnection = false,
    bool followRedirects = false,
    String clientIP = '',
    int? maxRedirects,
  }) {
    return PHttpRequest._(
      uri,
      requestId,
      method,
      data,
      headers,
      queryParameters,
      persistentConnection,
      followRedirects,
      clientIP,
      maxRedirects,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'uri': uri.toString(),
      'requestId': requestId,
      'method': method.toString(),
      'data': data,
      'headers': headers,
      'queryParameters': queryParameters,
      'persistentConnection': persistentConnection,
      'followRedirects': followRedirects,
      'clientIP': clientIP,
      'maxRedirects': maxRedirects,
    };
  }

  // fromJson
  factory PHttpRequest.fromJson(Map<String, dynamic> json) {
    return PHttpRequest(
      uri: Uri.parse(json['uri']),
      requestId: json['requestId'],
      method: PHttpMethod.parse(json['method']),
      data: json['data'],
      headers: json['headers'],
      queryParameters: json['queryParameters'],
      persistentConnection: json['persistentConnection'],
      followRedirects: json['followRedirects'],
      clientIP: json['clientIP'],
      maxRedirects: json['maxRedirects'],
    );
  }

  // copyWith
  PHttpRequest copyWith({
    Uri? uri,
    String? requestId,
    PHttpMethod? method,
    dynamic data,
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
      data: data ?? this.data,
      headers: headers ?? this.headers,
      queryParameters: queryParameters ?? this.queryParameters,
      persistentConnection: persistentConnection ?? this.persistentConnection,
      followRedirects: followRedirects ?? this.followRedirects,
      clientIP: clientIP ?? this.clientIP,
      maxRedirects: maxRedirects ?? this.maxRedirects,
    );
  }
}
