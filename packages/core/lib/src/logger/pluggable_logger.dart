// ignore_for_file: avoid_print

import 'package:pluggable/src/plug.dart';

abstract class PluggableLogger extends Plug<PluggableLogger> {
  void log(
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
  void log(
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
