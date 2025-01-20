typedef ApiException = ({Exception exception, StackTrace? stackTrace});

extension ApiExceptionExt on ApiException {
  Map<String, dynamic> toJson() {
    return {
      'exception': exception.toString(),
      'stackTrace': stackTrace.toString(),
    };
  }

  // toString
  String string() {
    return 'ApiException: $exception\nStackTrace: $stackTrace';
  }
}
