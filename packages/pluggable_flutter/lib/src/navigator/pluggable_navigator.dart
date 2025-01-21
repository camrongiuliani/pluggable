import 'package:flutter/material.dart';
import 'package:pluggable_flutter/pluggable_flutter.dart';

abstract class PluggableNavigator implements Plug<PluggableNavigator> {
  GlobalKey<NavigatorState> get key;

  RouterConfig<Object>? get config;

  BuildContext get context;

  /// Actual path
  String get currentRoute;

  Object? get data;

  List<NavigatorObserver> get observers;

  /// Query parameters
  Map<String, String> get queryParams;

  RouterDelegate get routerDelegate;

  void addListener(VoidCallback listener) {
    routerDelegate.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    routerDelegate.removeListener(listener);
  }

  Future<void> updateRoutes(
    Iterable<PluggableRouteBase> routes,
  );

  Future<T?> push<T extends Object?>(
    Route<T> route,
  );

  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    Map<String, String> queryParams = const {},
  });

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
    Map<String, String> queryParams = const {},
  });

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
    Map<String, String> queryParams = const {},
  });

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    Map<String, String> queryParams = const {},
  });

  void pop<T extends Object?>([T result]);

  bool canPop();

  Future<bool> maybePop<T extends Object?>([T result]);

  void popUntil(bool Function(Route<dynamic>) predicate);

  void navigate(
    String path, {
    Object? arguments,
    Map<String, String> queryParams = const {},
  });
}
