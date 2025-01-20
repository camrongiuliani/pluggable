// ignore_for_file: avoid_print

import 'package:pluggable/src/plug.dart';

abstract class PluggableLogger extends Plug<PluggableLogger> {
  /// Logs a verbose message.
  ///
  /// If [showPrefix] is `true`, the message will be prefixed with a vertical bar.
  void v(
    String message, {
    bool showPrefix = true,
    String? tag,
    Object? err,
    StackTrace? stackTrace,
  });

  /// Logs a debug message.
  void d(
    String message, {
    String? tag,
    Object? err,
    StackTrace? stackTrace,
  });

  /// Logs an information message.
  void i(
    String message, {
    String? tag,
    Object? err,
    StackTrace? stackTrace,
  });

  /// Logs a header message.
  void header(
    String message, {
    String? tag,
    Object? err,
    StackTrace? stackTrace,
  });

  /// Logs an error message.
  void e(
    String message, {
    String? tag,
    Object? err,
    StackTrace? stackTrace,
  });
}

class ConsoleLoggerPlug extends PluggableLogger {
  @override
  Future<PluggableLogger> init() async => this;

  @override
  Future<Plug> dispose() async => this;

  @override
  void v(
    String message, {
    bool showPrefix = true,
    String? tag,
    Object? err,
    StackTrace? stackTrace,
  }) =>
      _log(
        message,
        tag: tag,
        err: err,
        stackTrace: stackTrace,
      );

  @override
  void d(
    String message, {
    String? tag,
    Object? err,
    StackTrace? stackTrace,
  }) =>
      _log(
        message,
        tag: tag,
        err: err,
        stackTrace: stackTrace,
      );

  /// Logs an information message.
  void i(
    String message, {
    String? tag,
    Object? err,
    StackTrace? stackTrace,
  }) =>
      _log(
        message,
        tag: tag,
        err: err,
        stackTrace: stackTrace,
      );

  @override
  void header(
    String message, {
    String? tag,
    Object? err,
    StackTrace? stackTrace,
  }) =>
      _log(
        message,
        tag: tag,
        err: err,
        stackTrace: stackTrace,
      );

  @override
  void e(
    String message, {
    String? tag,
    Object? err,
    StackTrace? stackTrace,
  }) =>
      _log(
        message,
        tag: tag,
        err: err,
        stackTrace: stackTrace,
      );

  void _log(
    String message, {
    String? tag,
    Object? err,
    StackTrace? stackTrace,
  }) {
    print('[$tag] - $message');

    if (err != null) {
      print(err);
    }

    if (stackTrace != null) {
      print(stackTrace);
    }
  }
}
