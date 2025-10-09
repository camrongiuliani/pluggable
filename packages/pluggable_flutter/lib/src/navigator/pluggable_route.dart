import 'package:flutter/material.dart';
import 'package:pluggable_flutter/pluggable_flutter.dart';
import 'package:pluggable_flutter/src/navigator/routes/route_base.dart' as base;

typedef DetermineTransition = RouteTransition Function();

enum RouteTransition {
  none,
  fade,
  slideUp,
  slideDown,
  slideLeft,
}

/// A route in the Pluggable framework that supports various transition types.
///
/// This class extends [PluggableRouteBase] and provides different transition
/// options for route navigation.
///
/// Example usage:
/// ```dart
/// final route = PluggableRoute(
///   path: '/home',
///   builder: (context) => HomePage(),
///   transition: RouteTransition.slideLeft,
/// );
/// ```
class PluggableRoute extends base.PluggableRoute
    implements base.PluggableRouteBase {
  /// Creates a new [PluggableRoute].
  ///
  /// The [path] parameter is required and specifies the route path.
  /// The [builder] parameter is required and defines how to build the route's widget.
  /// The [transition] parameter specifies the transition type (defaults to none).
  /// The [data] parameter can be used to pass additional data to the route.
  PluggableRoute({
    required super.path,
    required base.PluggableRouterWidgetBuilder builder,
    super.parentNavigatorKey,
    super.redirect,
    super.onExit,
    super.routes = const <base.PluggableRouteBase>[],
    this.transition = RouteTransition.none,
  }) : super(
          name: Uri.parse(path).path,
          pageBuilder: (context, state) {
            return switch (transition) {
              RouteTransition.none => RouteTransitionPage.none(
                  key: state.pageKey,
                  child: builder(context, state),
                ),
              RouteTransition.fade => RouteTransitionPage.fade(
                  key: state.pageKey,
                  child: builder(context, state),
                ),
              RouteTransition.slideUp => RouteTransitionPage.slideUp(
                  key: state.pageKey,
                  child: builder(context, state),
                ),
              RouteTransition.slideDown => RouteTransitionPage.slideDown(
                  key: state.pageKey,
                  child: builder(context, state),
                ),
              RouteTransition.slideLeft => RouteTransitionPage.slideLeft(
                  key: state.pageKey,
                  child: builder(context, state),
                ),
            };
          },
        );

  /// The transition type for this route.
  final RouteTransition transition;

  PluggableRoute.redirect({
    required super.path,
    required base.PluggableRouteRedirect redirect,
    this.transition = RouteTransition.none,
  }) : super(
          redirect: redirect,
        );
}

/// A shell route in the Pluggable framework that supports nested navigation.
///
/// This class extends [PluggableShellRouteBase] and provides a way to create
/// nested navigation structures.
///
/// Example usage:
/// ```dart
/// final shellRoute = PluggableShellRoute(
///   path: '/dashboard',
///   builder: (context, child) => DashboardLayout(child: child),
///   routes: [
///     PluggableRoute(path: '/home', builder: (context) => HomePage()),
///     PluggableRoute(path: '/profile', builder: (context) => ProfilePage()),
///   ],
/// );
/// ```
class PluggableShellRoute extends base.PluggableShellRoute
    implements base.PluggableRouteBase {
  /// Creates a new [PluggableShellRoute].
  ///
  /// The [path] parameter is required and specifies the route path.
  /// The [builder] parameter is required and defines how to build the shell layout.
  /// The [routes] parameter contains the nested routes within this shell.
  PluggableShellRoute({
    required super.routes,
    super.redirect,
    super.observers,
    super.parentNavigatorKey,
    super.navigatorKey,
    super.restorationScopeId,
    this.transition = RouteTransition.none,
    super.builder,
    super.pageBuilder,
  });
  // : super(
  //         builder: builder,
  //         pageBuilder: (context, state, child) {
  //           final key = ValueKey('${state.pageKey.value}_${state.route.path}');
  //
  //           return switch (transition) {
  //             RouteTransition.none => RouteTransitionPage.none(
  //                 key: key,
  //                 child: builder?.call(context, state, child) ?? child,
  //               ),
  //             RouteTransition.fade => RouteTransitionPage.fade(
  //                 key: key,
  //                 child: builder?.call(context, state, child) ?? child,
  //               ),
  //             RouteTransition.slideUp => RouteTransitionPage.slideUp(
  //                 key: key,
  //                 child: builder?.call(context, state, child) ?? child,
  //               ),
  //             RouteTransition.slideDown => RouteTransitionPage.slideDown(
  //                 key: key,
  //                 child: builder?.call(context, state, child) ?? child,
  //               ),
  //             RouteTransition.slideLeft => RouteTransitionPage.slideLeft(
  //                 key: key,
  //                 child: builder?.call(context, state, child) ?? child,
  //               ),
  //           };
  //         },
  //       );

  /// The transition type for this route.
  final RouteTransition transition;

  PluggableShellRoute copyWith({
    List<base.PluggableRouteBase>? routes,
    base.PluggableRouteRedirect? redirect,
    base.PluggableShellRouteBuilder? builder,
    base.PluggableShellRoutePageBuilder? pageBuilder,
    List<NavigatorObserver>? observers,
    GlobalKey<NavigatorState>? parentNavigatorKey,
    GlobalKey<NavigatorState>? navigatorKey,
    String? restorationScopeId,
  }) {
    return PluggableShellRoute(
      routes: routes ?? this.routes,
      redirect: redirect ?? this.redirect,
      builder: builder ?? this.builder,
      pageBuilder: pageBuilder ?? this.pageBuilder,
      observers: observers ?? this.observers,
      parentNavigatorKey: parentNavigatorKey ?? this.parentNavigatorKey,
      navigatorKey: navigatorKey ?? this.navigatorKey,
      restorationScopeId: restorationScopeId ?? this.restorationScopeId,
    );
  }
}
