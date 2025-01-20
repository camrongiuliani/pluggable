
class PHttpResponse<T> {
  final Map<String, Object> headers;
  final int statusCode;
  final T? data;
  final String message;

  PHttpResponse._(
    this.headers,
    this.statusCode,
    this.data,
    this.message,
  );

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

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'headers': headers,
      'statusCode': statusCode,
      'data': data,
      'message': message,
    };
  }

  // fromJson
  factory PHttpResponse.fromJson(Map<String, dynamic> json) {
    return PHttpResponse(
      headers: json['headers'],
      statusCode: json['statusCode'],
      data: json['data'],
      message: json['message'],
    );
  }

  // copyWith
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
