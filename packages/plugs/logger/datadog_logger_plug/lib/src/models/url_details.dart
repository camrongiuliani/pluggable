class UrlDetails {
  final String path;
  final String host;
  final Map<String, dynamic> query;

  UrlDetails({
    required this.path,
    required this.host,
    required this.query,
  });

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'host': host,
      'query': query,
    };
  }
}
