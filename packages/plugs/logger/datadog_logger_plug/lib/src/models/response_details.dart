class ResponseDetails {
  final Map<String, dynamic> headers;
  final String? statusMessage;
  final int? statusCode;
  final dynamic body;

  ResponseDetails({
    required this.headers,
    this.statusMessage,
    this.statusCode,
    this.body,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'headers': headers,
      'statusMessage': statusMessage,
      'statusCode': statusCode,
    };

    if (body != null) data['body'] = body;

    return data;
  }

  ResponseDetails copyWith({
    Map<String, dynamic>? headers,
    String? statusMessage,
    int? statusCode,
    dynamic body,
  }) {
    return ResponseDetails(
      headers: headers ?? this.headers,
      statusMessage: statusMessage ?? this.statusMessage,
      statusCode: statusCode ?? this.statusCode,
      body: body ?? this.body,
    );
  }
}
