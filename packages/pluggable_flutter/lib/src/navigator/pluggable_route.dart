import 'package:pluggable_flutter/src/navigator/pluggable_route_transition.dart';
import 'package:pluggable_flutter/src/navigator/routes/route_base.dart' as base;

typedef DetermineTransition = RouteTransition Function();

enum RouteTransition {
  none,
  fade,
  slideUp,
  slideDown,
  slideLeft,
}

class PluggableRoute extends base.PluggableRoute
    implements base.PluggableRouteBase {
  PluggableRoute({
    required super.path,
    required base.PluggableRouterWidgetBuilder builder,
    super.parentNavigatorKey,
    super.redirect,
    super.onExit,
    super.routes = const <base.PluggableRouteBase>[],
    DetermineTransition? transition,
  }) : super(
          name: Uri.parse(path).path,
          pageBuilder: (context, state) {
            return switch (transition?.call() ?? RouteTransition.fade) {
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

  PluggableRoute.redirect({
    required super.path,
    required base.PluggableRouteRedirect redirect,
  }) : super(
          redirect: redirect,
        );
}

class PluggableShellRoute extends base.PluggableShellRoute
    implements base.PluggableRouteBase {
  PluggableShellRoute({
    required super.routes,
    super.redirect,
    super.builder,
    super.pageBuilder,
    super.observers,
    super.parentNavigatorKey,
    super.navigatorKey,
    super.restorationScopeId,
  });
}
