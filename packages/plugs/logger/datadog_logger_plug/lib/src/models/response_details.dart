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
}
