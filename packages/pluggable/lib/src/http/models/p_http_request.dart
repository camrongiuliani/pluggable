
import 'package:pluggable/pluggable.dart';

part 'p_http_form_data_request.dart';
part 'p_http_json_request.dart';

sealed class _BaseRequest {
  final Uri uri;
  final String requestId;
  final PHttpMethod method;
  final Map<String, Object> headers;
  final Map<String, dynamic> queryParameters;
  final bool persistentConnection;
  final bool followRedirects;
  final String clientIP;
  final int? maxRedirects;

  String get path => uri.path;

  String get host => uri.host;

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

class PHttpRequest extends _BaseRequest {
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

  // fromJson
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

  // toJson
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

  // copyWith
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

// class _RequestParser {
//   static Future<dynamic> parse({
//     required Map<String, Object> headers,
//     required dynamic data,
//   }) async {
//     final contentType = _extractContentType(headers);
//     final isFormUrlEncoded = _isFormUrlEncoded(contentType);
//     final isMultipartFormData = _isMultipartFormData(contentType);
//
//     return switch (isFormUrlEncoded || isMultipartFormData) {
//       true => context.request.formData(),
//       false => switch (_isJson(contentType)) {
//           true => context.request.json(),
//           false => switch (_isStream(contentType)) {
//               true => context.request.bytes(),
//               false => context.request.body(),
//             },
//         }
//     };
//   }
//
//   static ContentType? _extractContentType(Map<String, Object> headers) {
//     final contentTypeValue = headers[HttpHeaders.contentTypeHeader];
//     if (contentTypeValue == null || contentTypeValue is! String) return null;
//     return ContentType.parse(contentTypeValue);
//   }
//
//   static final formUrlEncodedContentType = ContentType(
//     'application',
//     'x-www-form-urlencoded',
//   );
//
//   /// Content-Type: multipart/form-data
//   static final multipartFormDataContentType = ContentType(
//     'multipart',
//     'form-data',
//   );
//
//   /// application: octet-stream
//   static final octetStreamDataContentType = ContentType(
//     'application',
//     'octet-stream',
//   );
//
//   static bool _isStream(ContentType? contentType) {
//     if (contentType == null) return false;
//     return contentType.mimeType == octetStreamDataContentType.mimeType;
//   }
//
//   static bool _isJson(ContentType? contentType) {
//     if (contentType == null) return false;
//     return contentType.mimeType == ContentType.json.mimeType;
//   }
//
//   static bool _isFormUrlEncoded(ContentType? contentType) {
//     if (contentType == null) return false;
//     return contentType.mimeType == formUrlEncodedContentType.mimeType;
//   }
//
//   static bool _isMultipartFormData(ContentType? contentType) {
//     if (contentType == null) return false;
//     return contentType.mimeType == multipartFormDataContentType.mimeType;
//   }
// }
