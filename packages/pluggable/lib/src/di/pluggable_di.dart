import 'dart:async';

import 'package:pluggable/src/plug.dart';

typedef DependencyDisposeFunc<T> = FutureOr Function(T param);
typedef DependencyBuilder<T> = T Function();

abstract class PluggableDI extends Plug<PluggableDI> {
  void allowReassignment();

  T get<T extends Object>();

  T? maybeGet<T extends Object>();

  void pushScope(String name);

  Future<void> popScope(String name);

  Future<void> replaceScope(String name);

  bool containsScope(String name);

  void addSingleton<T extends Object>(
      DependencyBuilder<T> constructor, {
        DependencyDisposeFunc<T>? dispose,
        String? name,
      });

  void addLazySingleton<T extends Object>(
      DependencyBuilder<T> constructor, {
        DependencyDisposeFunc<T>? dispose,
        String? name,
      });

  FutureOr unregister<T extends Object>({
    DependencyDisposeFunc? disposingFunction,
  });
}
