import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_plug/go_route_ext.dart';
import 'package:pluggable_flutter/pluggable_flutter.dart';

/// A navigation plugin that uses the GoRouter package for routing in Flutter applications.
///
/// This plugin provides a complete navigation solution using GoRouter, including:
/// - Route management
/// - Navigation methods (push, pop, etc.)
/// - Query parameter handling
/// - Route configuration
///
/// Example usage:
/// ```dart
/// final navigator = GoRouterPlug(
///   initialRoute: '/home',
/// );
///
/// await navigator.init();
/// navigator.navigate('/profile', queryParams: {'id': '123'});
/// ```
class GoRouterPlug extends PluggableNavigator {
  /// The underlying GoRouter instance.
  late final GoRouter _router;

  /// The initial route to navigate to when the app starts.
  final String initialRoute;

  /// Configuration for the router's routes.
  // late final ValueNotifier<RoutingConfig> _routeConfig;
  ValueNotifier<RoutingConfig>? _config;

  ValueNotifier<RoutingConfig> get _routeConfig => _config ??= ValueNotifier(
        const RoutingConfig(
          routes: [],
        ),
      );

  /// The navigator key used for navigation.
  @override
  late final GlobalKey<NavigatorState> key;

  /// Gets the router configuration.
  @override
  RouterConfig<Object> get config => _router;

  /// Creates a new GoRouter plugin.
  ///
  /// [initialRoute]: The route to navigate to when the app starts.
  GoRouterPlug({
    required this.initialRoute,
    GlobalKey<NavigatorState>? rootNavigatorKey,
  }) {
    key = rootNavigatorKey ?? GlobalKey<NavigatorState>(
      debugLabel: 'GoRouterPlug',
    );
  }

  /// Initializes the router with the specified configuration.
  ///
  /// Sets up the router with:
  /// - Navigation key
  /// - Route observers
  /// - Initial location
  /// - Route configuration
  /// - Error handling
  @override
  Future<Plug> init() async {
    _router = GoRouter.routingConfig(
      navigatorKey: key,
      observers: observers,
      initialLocation: initialRoute,
      routingConfig: _routeConfig,
      // onException: (context, state, router) {
      //   Pluggable.logger.e('Exception: ${state.error}', tag: 'CORE');
      //
      //   router.go('/error');
      // },
    );

    return this;
  }

  /// Updates the available routes in the router.
  ///
  /// [routes]: The new set of routes to use.
  @override
  Future<void> updateRoutes(
    Iterable<PluggableRouteBase> routes,
  ) async {
    final String initialPath = Uri.base.fragment;

    _routeConfig.value = RoutingConfig(
      redirect: (_, state) async {
        return switch (state.uri.toString()) {
          '/error' => initialRoute,
          '/' => switch (initialPath) {
              '' || '/' => initialRoute,
              _ => initialPath,
            },
          _ => null,
        };
      },
      routes: routes.asGoRoutes,
    );
  }

  /// Gets the list of navigation observers.
  @override
  List<NavigatorObserver> get observers => [];

  /// Gets the current build context.
  @override
  BuildContext get context => key.currentContext!;

  /// Gets the router delegate.
  @override
  RouterDelegate get routerDelegate => _router.routerDelegate;

  /// Gets the current route configuration.
  RouteMatchList get _currentConfiguration {
    return _router.routerDelegate.currentConfiguration;
  }

  /// Gets the current query parameters.
  @override
  Map<String, String> get queryParams {
    return _currentConfiguration.uri.queryParameters;
  }

  /// Gets the current route data.
  @override
  Object? get data {
    return _currentConfiguration.extra;
  }

  /// Gets the current route path.
  @override
  String get currentRoute {
    return _currentConfiguration.fullPath;
  }

  /// Checks if the current route can be popped.
  @override
  bool canPop() {
    return _router.canPop();
  }

  /// Attempts to pop the current route.
  ///
  /// [result]: Optional result to return to the previous route.
  @override
  Future<bool> maybePop<T extends Object?>([T? result]) async {
    if (_router.canPop()) {
      _router.pop(result);
      return true;
    }

    return false;
  }

  /// Navigates to a new route.
  ///
  /// [path]: The path to navigate to.
  /// [arguments]: Optional arguments to pass to the route.
  /// [queryParams]: Optional query parameters to include in the URL.
  @override
  void navigate(
    String path, {
    Object? arguments,
    Map<String, String> queryParams = const {},
  }) {
    final Uri uri = Uri.parse(path);

    _router.go(
      uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          ...queryParams,
        },
      ).toString(),
      extra: arguments,
    );
  }

  /// Pops the current route.
  ///
  /// [result]: Optional result to return to the previous route.
  @override
  void pop<T extends Object?>([T? result]) {
    _router.pop(result);
  }

  /// Pops the current route and pushes a new named route.
  ///
  /// [routeName]: The name of the route to push.
  /// [result]: Optional result to return to the previous route.
  /// [arguments]: Optional arguments to pass to the new route.
  /// [queryParams]: Optional query parameters to include in the URL.
  @override
  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    Map<String, String> queryParams = const {},
  }) async {
    final Uri uri = Uri.parse(routeName);

    _router.pop(result);

    return _router.push(
      uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          ...queryParams,
        },
      ).toString(),
      extra: arguments,
    );
  }

  /// Pops routes until the given predicate returns false.
  ///
  /// [predicate]: Function that determines whether to continue popping routes.
  @override
  void popUntil(bool Function(Route p1) predicate) {
    Route buildRoute() {
      return MaterialPageRoute(
        builder: (_) => Container(),
        settings: RouteSettings(
          name: _currentConfiguration.fullPath,
          arguments: _currentConfiguration.extra,
        ),
      );
    }

    while (_router.canPop() && predicate(buildRoute())) {
      _router.pop();
    }
  }

  /// Pushes a new route onto the navigation stack.
  ///
  /// [route]: The route to push.
  @override
  Future<T?> push<T extends Object?>(
    Route<T> route,
  ) {
    return Navigator.of(context).push(
      route,
    );
  }

  /// Pushes a named route onto the navigation stack.
  ///
  /// [routeName]: The name of the route to push.
  /// [arguments]: Optional arguments to pass to the route.
  /// [queryParams]: Optional query parameters to include in the URL.
  @override
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
    Map<String, String> queryParams = const {},
  }) {
    return _router.pushNamed(
      routeName,
      extra: arguments,
      queryParameters: queryParams,
    );
  }

  /// Pushes a named route and removes all previous routes until the predicate returns false.
  ///
  /// [newRouteName]: The name of the route to push.
  /// [predicate]: Function that determines which routes to remove.
  /// [arguments]: Optional arguments to pass to the new route.
  /// [queryParams]: Optional query parameters to include in the URL.
  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    bool Function(Route p1) predicate, {
    Object? arguments,
    Map<String, String> queryParams = const {},
  }) {
    final Uri uri = Uri.parse(newRouteName);

    return key.currentState!.pushNamedAndRemoveUntil(
      uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          ...queryParams,
        },
      ).toString(),
      predicate,
      arguments: arguments,
    );
  }

  /// Replaces the current route with a new named route.
  ///
  /// [routeName]: The name of the route to push.
  /// [result]: Optional result to return to the previous route.
  /// [arguments]: Optional arguments to pass to the new route.
  /// [queryParams]: Optional query parameters to include in the URL.
  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    Map<String, String> queryParams = const {},
  }) {
    final Uri uri = Uri.parse(routeName);

    return _router.pushReplacementNamed(
      uri.path,
      extra: arguments,
      queryParameters: {
        ...uri.queryParameters,
        ...queryParams,
      },
    );
  }

  /// Disposes of the router.
  @override
  Future<Plug> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }
}
