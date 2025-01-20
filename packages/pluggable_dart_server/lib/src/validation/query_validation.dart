
import 'package:pluggable_dart_server/pluggable_dart_server.dart';

class QueryParamValidation<T extends Object?> {
  final String key;
  final String? errorMessage;
  final bool throws;
  final ValidationOperation operation;
  final T? checkedValue;
  late final CustomValidator? customValidator;

  QueryParamValidation.exists({
    required this.key,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        checkedValue = null,
        errorMessage = errorMessage ?? '$key is required',
        operation = ValidationOperation.exists;

  QueryParamValidation.notNull({
    required this.key,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        checkedValue = null,
        errorMessage = errorMessage ?? '$key cannot be null',
        operation = ValidationOperation.notNull;

  QueryParamValidation.notNullOrEmpty({
    required this.key,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        checkedValue = null,
        errorMessage = errorMessage ?? '$key cannot be null or empty',
        operation = ValidationOperation.notNullOrEmpty;

  QueryParamValidation.equals({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage =
            errorMessage ?? '$key was not equal to an expected value',
        operation = ValidationOperation.equals;

  QueryParamValidation.notEquals({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage = errorMessage ?? '$key is an unsupported value',
        operation = ValidationOperation.notEquals;

  QueryParamValidation.contains({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage = errorMessage ?? '$key did not contain an expected value',
        operation = ValidationOperation.contains;

  QueryParamValidation.notContains({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage = errorMessage ?? '$key contained an unexpected value',
        operation = ValidationOperation.notContains;

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
