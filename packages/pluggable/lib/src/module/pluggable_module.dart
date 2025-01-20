import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:pluggable/src/di/pluggable_di.dart';
import 'package:pluggable/src/plug.dart';
import 'package:pluggable/src/pluggable/pluggable.dart';

abstract class PluggableModule extends Plug<PluggableModule> {
  late final UniqueKey _key;
  late final String _diKey;

  bool bound = false;

  StreamSubscription? ss;

  PluggableModule() {
    _key = UniqueKey();
    _diKey = '${runtimeType}_$_key';
  }

  @override
  Future<Plug> init() async => this;

  @override
  Future<Plug> dispose() async => this;

  void addDependencies(PluggableDI i) {}

  void bind([bool log = true]) {
    if (bound) {
      return;
    }

    if (log) {
      Pluggable.log('$runtimeType module bound', tag: '$runtimeType');
      Pluggable.di.pushScope(_diKey);
    }

    addDependencies(
      Pluggable.di,
    );

    bound = true;
  }

  void unbind() {
    if (!bound) {
      return;
    }

    Future.sync(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      Pluggable.log('$runtimeType module unbound', tag: '$runtimeType');
      Pluggable.di.popScope(_diKey);

      bound = false;
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PluggableModule && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
