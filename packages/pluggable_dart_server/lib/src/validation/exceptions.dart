/// Exception thrown when an argument is invalid.
///
/// This exception is used to indicate that a provided argument does not meet
/// the required criteria or is in an invalid format.
///
/// Example usage:
/// ```dart
/// if (value < 0) {
///   throw InvalidArgumentException('value', 'Value must be positive');
/// }
/// ```
class InvalidArgumentException implements Exception {
  /// The name of the invalid argument.
  final String argument;

  /// An optional message describing why the argument is invalid.
  final String? message;

  /// Creates a new invalid argument exception.
  InvalidArgumentException(this.argument, [this.message]);

  @override
  String toString() {
    return message ?? 'Invalid Arguments ($argument)';
  }
}

/// Exception thrown when a required argument is missing.
///
/// This exception is used to indicate that a required argument was not provided
/// when it was expected to be present.
///
/// Example usage:
/// ```dart
/// if (value == null) {
///   throw MissingRequiredArgumentException('value');
/// }
/// ```
class MissingRequiredArgumentException implements Exception {
  /// The name of the missing argument.
  final String argument;

  /// An optional message describing why the argument is required.
  final String? message;

  /// Creates a new missing required argument exception.
  MissingRequiredArgumentException(this.argument, [this.message]);

  @override
  String toString() {
    return message ?? '$argument is required but was not provided';
  }
}