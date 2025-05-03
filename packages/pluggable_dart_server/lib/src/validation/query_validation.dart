import 'package:pluggable_dart_server/pluggable_dart_server.dart';

/// A class for validating HTTP query parameters.
///
/// This class provides various validation operations for query parameters,
/// including existence checks, type validation, and value comparisons.
///
/// Example usage:
/// ```dart
/// final validator = QueryParamValidation.exists(
///   key: 'id',
///   errorMessage: 'ID parameter is required',
/// );
///
/// final error = validator.validate(queryParams);
/// if (error != null) {
///   throw error;
/// }
/// ```
class QueryParamValidation<T extends Object?> {
  /// The query parameter key to validate.
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

  /// Creates a validation rule that checks if a query parameter exists.
  ///
  /// [key]: The query parameter key to check.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  QueryParamValidation.exists({
    required this.key,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        checkedValue = null,
        errorMessage = errorMessage ?? '$key is required',
        operation = ValidationOperation.exists;

  /// Creates a validation rule that checks if a query parameter is not null.
  ///
  /// [key]: The query parameter key to check.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  QueryParamValidation.notNull({
    required this.key,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        checkedValue = null,
        errorMessage = errorMessage ?? '$key cannot be null',
        operation = ValidationOperation.notNull;

  /// Creates a validation rule that checks if a query parameter is not null or empty.
  ///
  /// [key]: The query parameter key to check.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  QueryParamValidation.notNullOrEmpty({
    required this.key,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        checkedValue = null,
        errorMessage = errorMessage ?? '$key cannot be null or empty',
        operation = ValidationOperation.notNullOrEmpty;

  /// Creates a validation rule that checks if a query parameter equals a value.
  ///
  /// [key]: The query parameter key to check.
  /// [checkedValue]: The value to compare against.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  QueryParamValidation.equals({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage =
            errorMessage ?? '$key was not equal to an expected value',
        operation = ValidationOperation.equals;

  /// Creates a validation rule that checks if a query parameter does not equal a value.
  ///
  /// [key]: The query parameter key to check.
  /// [checkedValue]: The value to compare against.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  QueryParamValidation.notEquals({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage = errorMessage ?? '$key is an unsupported value',
        operation = ValidationOperation.notEquals;

  /// Creates a validation rule that checks if a query parameter contains a value.
  ///
  /// [key]: The query parameter key to check.
  /// [checkedValue]: The value to check for.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  QueryParamValidation.contains({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage = errorMessage ?? '$key did not contain an expected value',
        operation = ValidationOperation.contains;

  /// Creates a validation rule that checks if a query parameter does not contain a value.
  ///
  /// [key]: The query parameter key to check.
  /// [checkedValue]: The value to check for.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  QueryParamValidation.notContains({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage = errorMessage ?? '$key contained an unexpected value',
        operation = ValidationOperation.notContains;

  /// Creates a validation rule that checks if a query parameter is greater than a value.
  ///
  /// [key]: The query parameter key to check.
  /// [checkedValue]: The value to compare against.
  /// [orEqual]: Whether to allow equality.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  QueryParamValidation.greaterThan({
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

  /// Creates a validation rule that checks if a query parameter is less than a value.
  ///
  /// [key]: The query parameter key to check.
  /// [checkedValue]: The value to compare against.
  /// [orEqual]: Whether to allow equality.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  QueryParamValidation.lessThan({
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

  /// Creates a validation rule that checks if a query parameter is of a specific type.
  ///
  /// [key]: The query parameter key to check.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  QueryParamValidation.isType({
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

  /// Creates a validation rule that checks if a query parameter is a number.
  ///
  /// [key]: The query parameter key to check.
  /// [throws]: Whether to throw an exception on failure.
  /// [errorMessage]: Custom error message.
  QueryParamValidation.isNum({
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

  /// Validates the query parameters against the configured rules.
  ///
  /// [parameters]: The query parameters to validate.
  /// Returns an exception if validation fails, or null if validation passes.
  Exception? validate(
    Map<String, dynamic> parameters,
  ) {
    if (!parameters.keys.contains(key)) {
      return MissingRequiredArgumentException(key);
    }

    if (parameters[key] is! T) {
      return InvalidArgumentException(key, errorMessage);
    }

    return switch (operation) {
      ValidationOperation.exists => null, // Caught by line 137
      ValidationOperation.equals => _equals(parameters),
      ValidationOperation.notEquals => _equals(parameters, true),
      ValidationOperation.contains => _contains(parameters),
      ValidationOperation.notContains => _contains(parameters, true),
      ValidationOperation.greaterThan => _greaterThan(parameters),
      ValidationOperation.greaterThanOrEqual => _greaterThan(parameters, true),
      ValidationOperation.lessThan => _lessThan(parameters),
      ValidationOperation.lessThanOrEqual => _lessThan(parameters, true),
      ValidationOperation.notNull => _notNull(parameters),
      ValidationOperation.notNullOrEmpty => _notNull(parameters, true),
      ValidationOperation.custom => customValidator?.call(parameters),
    };
  }

  /// Validates that a query parameter is not null (and optionally not empty).
  Exception? _notNull(
    Map<String, dynamic> parameters, [
    bool orEmpty = false,
  ]) {
    if (parameters[key] == null) {
      return InvalidArgumentException(key, errorMessage);
    }

    if (orEmpty) {
      final val = parameters[key];

      assert(val is String || val is Iterable);

      if (val.isEmpty) {
        return InvalidArgumentException(key, errorMessage);
      }
    }

    return null;
  }

  /// Validates that a query parameter equals (or does not equal) a value.
  Exception? _equals(
    Map<String, dynamic> parameters, [
    bool not = false,
  ]) {
    if (not) {
      if (parameters[key] == checkedValue) {
        return InvalidArgumentException(key, errorMessage);
      }
    } else if (parameters[key] != checkedValue) {
      return InvalidArgumentException(key, errorMessage);
    }

    return null;
  }

  /// Validates that a query parameter contains (or does not contain) a value.
  Exception? _contains(
    Map<String, dynamic> parameters, [
    bool not = false,
  ]) {
    var param = parameters[key];

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

  /// Validates that a query parameter is greater than (or equal to) a value.
  Exception? _greaterThan(
    Map<String, dynamic> parameters, [
    bool orEqual = false,
  ]) {
    var param = parameters[key];

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

  /// Validates that a query parameter is less than (or equal to) a value.
  Exception? _lessThan(
    Map<String, dynamic> parameters, [
    bool orEqual = false,
  ]) {
    var param = parameters[key];

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

class QueryParamValidator {
  final List<QueryParamValidation> get, put, post, delete, head, patch, options;

  QueryParamValidator({
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
    required Map<String, dynamic> parameters,
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
      final exception = rule.validate(parameters);

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
