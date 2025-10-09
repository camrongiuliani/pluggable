class RequestDetails {
  final Map<String, dynamic> headers;
  final dynamic body;

  RequestDetails({
    required this.headers,
    this.body,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'headers': headers,
    };

    if (body != null && body.toString().isNotEmpty && body is Map) {
      data['body'] = body;
    }

    return data;
  }
}
