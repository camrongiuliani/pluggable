/// Enumeration of supported validation operations.
///
/// This enum defines the types of validation operations that can be performed
/// on request parameters and headers. Each operation corresponds to a specific
/// validation rule that can be applied to the data.
///
/// Example usage:
/// ```dart
/// final validator = QueryParamValidator({
///   'id': ValidationOperation.notNull,
///   'count': ValidationOperation.greaterThan(0),
/// });
/// ```
enum ValidationOperation {
  /// Custom validation operation defined by a function.
  custom,

  /// Checks if the value contains the specified substring.
  contains,

  /// Checks if the value does not contain the specified substring.
  notContains,

  /// Checks if the value equals the specified value.
  equals,

  /// Checks if the value exists in the data.
  exists,

  /// Checks if the value does not equal the specified value.
  notEquals,

  /// Checks if the value is not null.
  notNull,

  /// Checks if the value is not null and not empty.
  notNullOrEmpty,

  /// Checks if the value is greater than the specified value.
  greaterThan,

  /// Checks if the value is greater than or equal to the specified value.
  greaterThanOrEqual,

  /// Checks if the value is less than the specified value.
  lessThan,

  /// Checks if the value is less than or equal to the specified value.
  lessThanOrEqual,
}

/// Type definition for custom validation functions.
///
/// A custom validator is a function that takes a map of data to validate
/// and returns an exception if validation fails, or null if validation passes.
///
/// Example usage:
/// ```dart
/// CustomValidator validateEmail = (data) {
///   if (!data['email'].toString().contains('@')) {
///     return ValidationException('Invalid email format');
///   }
///   return null;
/// };
/// ```
typedef CustomValidator = Exception? Function(Map<String, dynamic>);
