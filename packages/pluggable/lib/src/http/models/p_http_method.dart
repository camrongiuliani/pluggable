/// Enum representing HTTP methods used in requests.
/// 
/// This enum provides a type-safe way to specify HTTP methods in requests.
/// It includes all standard HTTP methods and provides parsing functionality
/// from string values.
/// 
/// Example usage:
/// ```dart
/// final request = PHttpRequest(
///   method: PHttpMethod.get,
///   url: 'https://api.example.com/data',
/// );
/// ```

/// {@template http_method}
/// HTTP Method such as GET or PUT.
/// {@endtemplate}
enum PHttpMethod {
  /// DELETE HTTP Method
  /// 
  /// Used to delete a resource on the server
  delete('DELETE'),

  /// GET HTTP Method
  /// 
  /// Used to retrieve a resource from the server
  get('GET'),

  /// HEAD HTTP Method
  /// 
  /// Similar to GET but only retrieves headers, not the body
  head('HEAD'),

  /// OPTIONS HTTP Method
  /// 
  /// Used to describe the communication options for the target resource
  options('OPTIONS'),

  /// PATCH HTTP Method
  /// 
  /// Used to apply partial modifications to a resource
  patch('PATCH'),

  /// POST HTTP Method
  /// 
  /// Used to submit an entity to the specified resource
  post('POST'),

  /// PUT HTTP Method
  /// 
  /// Used to replace all current representations of the target resource
  put('PUT');

  /// {@macro http_method}
  const PHttpMethod(this.value);

  /// The HTTP method value as a string.
  final String value;

  /// Parses a string value into a [PHttpMethod] enum value
  /// 
  /// [value] - The string value to parse
  /// 
  /// Throws an [ArgumentError] if the value is not a valid HTTP method
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
