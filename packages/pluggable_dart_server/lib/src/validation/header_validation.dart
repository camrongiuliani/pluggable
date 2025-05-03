import 'package:pluggable_dart_server/pluggable_dart_server.dart';

/// A class for validating HTTP request headers.
///
/// This class provides various validation operations for HTTP headers,
/// including existence checks, type validation, and value comparisons.
///
/// Example usage:
/// ```dart
/// final validator = HeaderValidation.exists(
///   key: 'Authorization',
///   errorMessage: 'Authorization header is required',
/// );
///
/// final error = validator.validate(headers);
/// if (error != null) {
///   throw error;
/// }
/// ```
class HeaderValidation<T extends Object?> {
  /// The header key to validate.
  final String key;

  /// The error message to use if validation fails.
  final String? errorMessage;

  /// Whether to throw an exception on validation failure.
  final bool throws;

  /// The validation operation to perform.
  final ValidationOperation operation;

  /// The value to check against during validation.
  final T? checkedValue;

  /// Custom validation function for complex validation rules.
  late final CustomValidator? customValidator;

  /// Creates a validation rule that checks if a header exists.
  ///
  /// [key]: The header key to check.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  HeaderValidation.exists({
    required this.key,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        checkedValue = null,
        errorMessage = errorMessage ?? '$key is a required header',
        operation = ValidationOperation.exists;

  /// Creates a validation rule that checks if a header is not null.
  ///
  /// [key]: The header key to check.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  HeaderValidation.notNull({
    required this.key,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        checkedValue = null,
        errorMessage = errorMessage ?? '$key cannot be null',
        operation = ValidationOperation.notNull;

  /// Creates a validation rule that checks if a header is not null or empty.
  ///
  /// [key]: The header key to check.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  HeaderValidation.notNullOrEmpty({
    required this.key,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        checkedValue = null,
        errorMessage = errorMessage ?? '$key cannot be null or empty',
        operation = ValidationOperation.notNullOrEmpty;

  /// Creates a validation rule that checks if a header equals a value.
  ///
  /// [key]: The header key to check.
  /// [checkedValue]: The value to compare against.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  HeaderValidation.equals({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage =
            errorMessage ?? '$key was not equal to an expected value',
        operation = ValidationOperation.equals;

  /// Creates a validation rule that checks if a header does not equal a value.
  ///
  /// [key]: The header key to check.
  /// [checkedValue]: The value to compare against.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  HeaderValidation.notEquals({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage = errorMessage ?? '$key is an unsupported value',
        operation = ValidationOperation.notEquals;

  /// Creates a validation rule that checks if a header contains a value.
  ///
  /// [key]: The header key to check.
  /// [checkedValue]: The value to check for.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  HeaderValidation.contains({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage = errorMessage ?? '$key did not contain an expected value',
        operation = ValidationOperation.contains;

  /// Creates a validation rule that checks if a header does not contain a value.
  ///
  /// [key]: The header key to check.
  /// [checkedValue]: The value to check for.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  HeaderValidation.notContains({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage = errorMessage ?? '$key contained an unexpected value',
        operation = ValidationOperation.notContains;

  /// Creates a validation rule that checks if a header is greater than a value.
  ///
  /// [key]: The header key to check.
  /// [checkedValue]: The value to compare against.
  /// [orEqual]: Whether to allow equality.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  HeaderValidation.greaterThan({
    required this.key,
    required num checkedValue,
    bool orEqual = false,
    this.throws = true,
    String? errorMessage,
  })  : checkedValue = checkedValue as T,
        customValidator = null,
        errorMessage = errorMessage ?? '$key was out of range',
        operation = switch (orEqual) {
          true => ValidationOperation.greaterThanOrEqual,
          false => ValidationOperation.greaterThan,
        };

  /// Creates a validation rule that checks if a header is less than a value.
  ///
  /// [key]: The header key to check.
  /// [checkedValue]: The value to compare against.
  /// [orEqual]: Whether to allow equality.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  HeaderValidation.lessThan({
    required this.key,
    required num checkedValue,
    bool orEqual = false,
    this.throws = true,
    String? errorMessage,
  })  : checkedValue = checkedValue as T,
        customValidator = null,
        errorMessage = errorMessage ?? '$key was out of range',
        operation = switch (orEqual) {
          true => ValidationOperation.lessThanOrEqual,
          false => ValidationOperation.lessThan,
        };

  /// Creates a validation rule that checks if a header is of a specific type.
  ///
  /// [key]: The header key to check.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  HeaderValidation.isType({
    required this.key,
    this.throws = true,
    String? errorMessage,
  })  : checkedValue = null,
        errorMessage = errorMessage ?? '$key was an unsupported type',
        operation = ValidationOperation.custom {
    this.customValidator = (map) {
      return switch (map[key] is T) {
        true => null,
        false => InvalidArgumentException(key, errorMessage),
      };
    };
  }

  /// Creates a validation rule that checks if a header is a number.
  ///
  /// [key]: The header key to check.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  HeaderValidation.isNum({
    required this.key,
    this.throws = true,
    String? errorMessage,
  })  : checkedValue = null,
        errorMessage = errorMessage ?? '$key must be a number',
        operation = ValidationOperation.custom {
    this.customValidator = (map) {
      final num? number = num.tryParse(map[key] ?? '');
      return switch (number == null) {
        false => null,
        true => InvalidArgumentException(key, errorMessage),
      };
    };
  }

  /// Validates the headers against the configured rules.
  ///
  /// [headers]: The headers to validate.
  /// Returns an exception if validation fails, or null if validation passes.
  Exception? validate(
    Map<String, dynamic> headers,
  ) {
    return switch (operation) {
      ValidationOperation.exists => _exists(headers),
      ValidationOperation.equals => _equals(headers),
      ValidationOperation.notEquals => _equals(headers, true),
      ValidationOperation.contains => _contains(headers),
      ValidationOperation.notContains => _contains(headers, true),
      ValidationOperation.greaterThan => _greaterThan(headers),
      ValidationOperation.greaterThanOrEqual => _greaterThan(headers, true),
      ValidationOperation.lessThan => _lessThan(headers),
      ValidationOperation.lessThanOrEqual => _lessThan(headers, true),
      ValidationOperation.notNull => _notNull(headers),
      ValidationOperation.notNullOrEmpty => _notNull(headers, true),
      ValidationOperation.custom => customValidator?.call(headers),
    };
  }

  /// Validates that a header is not null (and optionally not empty).
  Exception? _notNull(
    Map<String, dynamic> headers, [
    bool orEmpty = false,
  ]) {
    if (headers[key] == null) {
      return InvalidArgumentException(key, errorMessage);
    }

    if (orEmpty) {
      final val = headers[key];

      assert(val is String || val is Iterable);

      if (val.isEmpty) {
        return InvalidArgumentException(key, errorMessage);
      }
    }

    return null;
  }

  /// Validates that a header exists.
  Exception? _exists(
    Map<String, dynamic> headers,
  ) {
    if (!headers.containsKey(key)) {
      return InvalidArgumentException(key, errorMessage);
    }

    return null;
  }

  /// Validates that a header equals (or does not equal) a value.
  Exception? _equals(
    Map<String, dynamic> headers, [
    bool not = false,
  ]) {
    if (not) {
      if (headers[key] == checkedValue) {
        return InvalidArgumentException(key, errorMessage);
      }
    } else if (headers[key] != checkedValue) {
      return InvalidArgumentException(key, errorMessage);
    }

    return null;
  }

  /// Validates that a header contains (or does not contain) a value.
  Exception? _contains(
    Map<String, dynamic> headers, [
    bool not = false,
  ]) {
    var param = headers[key];

    if (param.contains(',')) {
      param = param.split(',');
    }

    if (param is! Iterable && param is! String) {
      return InvalidArgumentException(key, errorMessage);
    }

    if (not) {
      if (param.contains(checkedValue)) {
        return InvalidArgumentException(key, errorMessage);
      }
    } else if (param.contains(checkedValue)) {
      return InvalidArgumentException(key, errorMessage);
    }

    return null;
  }

  /// Validates that a header is greater than (or equal to) a value.
  Exception? _greaterThan(
    Map<String, dynamic> headers, [
    bool orEqual = false,
  ]) {
    var param = headers[key];

    if (param is! num) {
      param = num.tryParse(param);
    }

    if (orEqual) {
      if (!(param >= checkedValue)) {
        return InvalidArgumentException(key, errorMessage);
      }
    } else if (!(param > checkedValue)) {
      return InvalidArgumentException(key, errorMessage);
    }

    return null;
  }

  /// Validates that a header is less than (or equal to) a value.
  Exception? _lessThan(
    Map<String, dynamic> headers, [
    bool orEqual = false,
  ]) {
    var param = headers[key];

    if (param is! num) {
      param = num.tryParse(param);
    }

    if (orEqual) {
      if (!(param <= checkedValue)) {
        return InvalidArgumentException(key, errorMessage);
      }
    } else if (!(param < checkedValue)) {
      return InvalidArgumentException(key, errorMessage);
    }

    return null;
  }
}

class HeaderValidator {
  final List<HeaderValidation> get, put, post, delete, head, patch, options;

  HeaderValidator({
    this.get = const [],
    this.put = const [],
    this.post = const [],
    this.delete = const [],
    this.head = const [],
    this.patch = const [],
    this.options = const [],
  });

  bool validate({
    required PHttpMethod httpMethod,
    required Map<String, dynamic> headers,
  }) {
    final rules = switch (httpMethod) {
      PHttpMethod.get => get,
      PHttpMethod.put => put,
      PHttpMethod.post => post,
      PHttpMethod.delete => delete,
      PHttpMethod.head => head,
      PHttpMethod.patch => patch,
      PHttpMethod.options => options,
    };

    for (final rule in rules) {
      final exception = rule.validate(headers);

      if (exception != null) {
        if (rule.throws) {
          throw exception;
        } else {
          return false;
        }
      }
    }

    return true;
  }
}
