import 'package:flutter/material.dart';
import 'package:pluggable_flutter/pluggable_flutter.dart';

/// Abstract class for navigation plugins in the Pluggable framework.
///
/// This class defines the interface for navigation plugins, providing
/// methods for route management, navigation, and state access.
///
/// Example usage:
/// ```dart
/// class MyNavigator extends PluggableNavigator {
///   @override
///   GlobalKey<NavigatorState> get key => GlobalKey<NavigatorState>();
///
///   @override
///   RouterConfig<Object>? get config => null;
///
///   @override
///   BuildContext get context => key.currentContext!;
///
///   @override
///   Future<void> updateRoutes(Iterable<PluggableRouteBase> routes) async {
///     // Update routes implementation
///   }
/// }
/// ```
abstract class PluggableNavigator extends Plug<PluggableNavigator> {
  /// The navigator key used for navigation.
  GlobalKey<NavigatorState> get key;

  /// The router configuration.
  RouterConfig<Object>? get config;

  /// The current build context.
  BuildContext get context;

  /// The current route path.
  String get currentRoute;

  /// The current route data.
  Object? get data;

  /// The list of navigation observers.
  List<NavigatorObserver> get observers;

  /// The current query parameters.
  Map<String, String> get queryParams;

  /// The router delegate.
  RouterDelegate get routerDelegate;

  /// Adds a listener to the router delegate.
  void addListener(VoidCallback listener) {
    routerDelegate.addListener(listener);
  }

  /// Removes a listener from the router delegate.
  void removeListener(VoidCallback listener) {
    routerDelegate.removeListener(listener);
  }

  /// Updates the available routes in the router.
  Future<void> updateRoutes(
    Iterable<PluggableRouteBase> routes,
  );

  /// Pushes a new route onto the navigation stack.
  Future<T?> push<T extends Object?>(
    Route<T> route,
  );

  /// Pops the current route and pushes a new named route.
  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    Map<String, String> queryParams = const {},
  });

  /// Pushes a named route onto the navigation stack.
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
    Map<String, String> queryParams = const {},
  });

  /// Pushes a named route and removes all previous routes until the predicate returns false.
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
    Map<String, String> queryParams = const {},
  });

  /// Replaces the current route with a new named route.
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    Map<String, String> queryParams = const {},
  });

  /// Pops the current route.
  void pop<T extends Object?>([T result]);

  /// Checks if the current route can be popped.
  bool canPop();

  /// Attempts to pop the current route.
  Future<bool> maybePop<T extends Object?>([T result]);

  /// Pops routes until the given predicate returns false.
  void popUntil(bool Function(Route<dynamic>) predicate);

  /// Navigates to a new route.
  void navigate(
    String path, {
    Object? arguments,
    Map<String, String> queryParams = const {},
  });
}
