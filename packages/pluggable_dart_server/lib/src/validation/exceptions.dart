class InvalidArgumentException implements Exception {
  final String argument;
  final String? message;

  InvalidArgumentException(this.argument, [this.message]);

  @override
  String toString() {
    return message ?? 'Invalid Arguments ($argument)';
  }
}

class MissingRequiredArgumentException implements Exception {
  final String argument;
  final String? message;

  MissingRequiredArgumentException(this.argument, [this.message]);

  @override
  String toString() {
    return message ?? '$argument is required but was not provided';
  }
}