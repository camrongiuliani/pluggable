import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_plug/go_route_ext.dart';
import 'package:pluggable_flutter/pluggable_flutter.dart';
import 'package:collection/collection.dart';

class GoRouterPlug extends PluggableNavigator {
  late final GoRouter _router;
  final String initialRoute;

  final _routeConfig = ValueNotifier<RoutingConfig>(RoutingConfig(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const SizedBox.shrink(),
      ),
    ],
  ));

  @override
  late final GlobalKey<NavigatorState> key;

  @override
  RouterConfig<Object> get config => _router;

  GoRouterPlug({
    required this.initialRoute,
  }) {
    key = GlobalKey<NavigatorState>();
  }

  @override
  Future<Plug> init() async {
    _router = GoRouter.routingConfig(
      navigatorKey: key,
      observers: observers,
      initialLocation: initialRoute,
      routingConfig: _routeConfig,
      onException: (context, state, router) {
        Pluggable.log('Exception: ${state.error}', tag: 'CORE');

        router.go('/error');
      },
      // redirect: (context, state) {
      //   if (state.uri.path == '/error') {
      //     return initialRoute;
      //   }
      //   return null;
      // },
    );

    return this;
  }

  @override
  Future<void> updateRoutes(
    Iterable<PluggableRouteBase> routes,
  ) async {
    _routeConfig.value = RoutingConfig(
      routes: routes
          .map(
            (route) => route.asGoRoute,
          )
          .toList(),
    );
  }

  @override
  List<NavigatorObserver> get observers => [];

  @override
  BuildContext get context => key.currentContext!;

  @override
  RouterDelegate get routerDelegate => _router.routerDelegate;

  RouteMatchList get _currentConfiguration {
    return _router.routerDelegate.currentConfiguration;
  }

  @override
  Map<String, String> get queryParams {
    return _currentConfiguration.uri.queryParameters;
  }

  @override
  Object? get data {
    return _currentConfiguration.extra;
  }

  @override
  String get currentRoute {
    return _currentConfiguration.fullPath;
  }

  @override
  bool canPop() {
    return _router.canPop();
  }

  @override
  Future<bool> maybePop<T extends Object?>([T? result]) async {
    if (_router.canPop()) {
      _router.pop(result);
      return true;
    }

    return false;
  }

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

  @override
  void pop<T extends Object?>([T? result]) {
    _router.pop(result);
  }

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

  @override
  Future<T?> push<T extends Object?>(
    Route<T> route,
  ) {
    return Navigator.of(context).push(
      route,
    );
  }

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

  @override
  Future<Plug> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }
}
