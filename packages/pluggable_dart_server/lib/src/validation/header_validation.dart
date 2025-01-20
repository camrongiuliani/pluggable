
import 'package:pluggable_dart_server/pluggable_dart_server.dart';

class HeaderValidation<T extends Object?> {
  final String key;
  final String? errorMessage;
  final bool throws;
  final ValidationOperation operation;
  final T? checkedValue;
  late final CustomValidator? customValidator;

  HeaderValidation.exists({
    required this.key,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        checkedValue = null,
        errorMessage = errorMessage ?? '$key is a required header',
        operation = ValidationOperation.exists;

  HeaderValidation.notNull({
    required this.key,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        checkedValue = null,
        errorMessage = errorMessage ?? '$key cannot be null',
        operation = ValidationOperation.notNull;

  HeaderValidation.notNullOrEmpty({
    required this.key,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        checkedValue = null,
        errorMessage = errorMessage ?? '$key cannot be null or empty',
        operation = ValidationOperation.notNullOrEmpty;

  HeaderValidation.equals({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage =
            errorMessage ?? '$key was not equal to an expected value',
        operation = ValidationOperation.equals;

  HeaderValidation.notEquals({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage = errorMessage ?? '$key is an unsupported value',
        operation = ValidationOperation.notEquals;

  HeaderValidation.contains({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage = errorMessage ?? '$key did not contain an expected value',
        operation = ValidationOperation.contains;

  HeaderValidation.notContains({
    required this.key,
    required this.checkedValue,
    this.throws = true,
    String? errorMessage,
  })  : customValidator = null,
        errorMessage = errorMessage ?? '$key contained an unexpected value',
        operation = ValidationOperation.notContains;

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

  Exception? _exists(
    Map<String, dynamic> headers,
  ) {
    if (!headers.containsKey(key)) {
      return InvalidArgumentException(key, errorMessage);
    }

    return null;
  }

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
