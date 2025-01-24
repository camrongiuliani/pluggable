
import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:pluggable/pluggable.dart';

class PluggableGetIt extends PluggableDI {
  PluggableGetIt() {
    _instance = GetIt.instance;
  }

  late final GetIt _instance;

  @override
  Future<Plug> init() async {
    return this;
  }

  @override
  Future<Plug> dispose() async {
    return this;
  }

  @override
  T get<T extends Object>() {
    final value = maybeGet<T>();

    if (value == null) {
      // debugPrint('DI: $T is not a registered dependency.');
      // debugPrint(StackTrace.current.toString());
      throw StateError('DI: $T is not a registered dependency.');
    }

    return value;
  }

  @override
  FutureOr unregister<T extends Object>({
    FutureOr Function(T)? disposingFunction,
  }) {
    if (!_instance.isRegistered<T>()) {
      return null;
    }

    return _instance.unregister<T>(
      disposingFunction: disposingFunction,
    );
  }

  @override
  T? maybeGet<T extends Object>() {
    if (!_instance.isRegistered<T>()) {
      return null;
    }

    return _instance.get<T>();
  }

  @override
  void pushScope(String name) {
    _instance.pushNewScope(
      scopeName: name,
    );

    Pluggable.logger.v('Pushed DI scope ($name)', tag: '$runtimeType');
  }

  @override
  Future<void> popScope(String name) async {
    if (!_instance.hasScope(name)) {
      return;
    }

    Pluggable.logger.v('Popped DI scope ($name)', tag: '$runtimeType');

    return _instance.dropScope(name);
  }

  @override
  Future<void> replaceScope(String name) async {
    if (_instance.hasScope(name)) {
      return popScope(name).then((_) {
        pushScope(name);
      });
    }
  }

  @override
  bool containsScope(String name) {
    return _instance.hasScope(name);
  }

  @override
  void allowReassignment() {
    _instance.allowReassignment = true;
  }

  @override
  void addSingleton<T extends Object>(
      DependencyBuilder<T> constructor, {
        DependencyDisposeFunc<T>? dispose,
        String? name,
      }) {
    _instance.registerSingleton<T>(
      constructor.call(),
      instanceName: name,
      dispose: dispose,
    );
  }

  @override
  void addLazySingleton<T extends Object>(
      DependencyBuilder<T> constructor, {
        DependencyDisposeFunc<T>? dispose,
        String? name,
      }) {
    _instance.registerLazySingleton<T>(
      constructor,
      instanceName: name,
      dispose: dispose,
    );
  }
}