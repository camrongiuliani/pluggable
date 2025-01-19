import 'package:flutter/cupertino.dart';
import 'package:pluggable/src/plug.dart';

abstract class PluggableAnalytics extends Plug<PluggableAnalytics> {
  void log(
    String message, {
    String? tag,
    Object? err,
    StackTrace? stackTrace,
  });

  void addExtraInfo(
    Map<String, Object?> info,
  );

  void setUserInfo({
    String? id,
    String? name,
    String? email,
    Map<String, Object?> extraInfo = const {},
  });
}

class NoAnalyticsPlug extends PluggableAnalytics {
  @override
  Future<PluggableAnalytics> init() async => this;

  @override
  Future<Plug> dispose() async => this;

  @override
  void log(
    String message, {
    String? tag,
    Object? err,
    StackTrace? stackTrace,
  }) {}

  @override
  void addExtraInfo(
    Map<String, Object?> info,
  ) {}

  @override
  void setUserInfo({
    String? id,
    String? name,
    String? email,
    Map<String, Object?> extraInfo = const {},
  }) {}
}
