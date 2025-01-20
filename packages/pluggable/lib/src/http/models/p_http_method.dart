/// {@template http_method}
/// HTTP Method such as GET or PUT.
/// {@endtemplate}
enum PHttpMethod {
  /// DELETE HTTP Method
  delete('DELETE'),

  /// GET HTTP Method
  get('GET'),

  /// HEAD HTTP Method
  head('HEAD'),

  /// OPTIONS HTTP Method
  options('OPTIONS'),

  /// PATCH HTTP Method
  patch('PATCH'),

  /// POST HTTP Method
  post('POST'),

  /// PUT HTTP Method
  put('PUT');

  /// {@macro http_method}
  const PHttpMethod(this.value);

  /// The HTTP method value as a string.
  final String value;

  // parse
  static PHttpMethod parse(String? value) {
    switch (value) {
      case 'DELETE':
        return PHttpMethod.delete;
      case 'GET':
        return PHttpMethod.get;
      case 'HEAD':
        return PHttpMethod.head;
      case 'OPTIONS':
        return PHttpMethod.options;
      case 'PATCH':
        return PHttpMethod.patch;
      case 'POST':
        return PHttpMethod.post;
      case 'PUT':
        return PHttpMethod.put;
      default:
        throw ArgumentError('Invalid HTTP method: $value');
    }
  }
}
