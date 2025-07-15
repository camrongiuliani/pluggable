import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import 'package:pluggable_flutter/pluggable_flutter.dart';
import 'package:go_router/go_router.dart';

typedef Remap = ({
  GlobalKey<NavigatorState> source,
  GlobalKey<NavigatorState> destination,
});

/// Extension on [Iterable<PluggableRouteBase>] to convert a list of Pluggable routes to GoRouter routes.
extension GoRouteListConverter on Iterable<PluggableRouteBase> {
  /// Converts a list of Pluggable routes to a list of GoRouter routes.
  ///
  /// This extension method allows you to easily convert a collection of
  /// Pluggable routes into their GoRouter equivalents, making it convenient
  /// to work with both routing systems.
  List<RouteBase> get asGoRoutes {
    Map<Remap, List<PluggableShellRoute>> remapMap = {};

    for (final route in this) {
      if (route is PluggableShellRoute) {
        final matches = whereType<PluggableShellRoute>().where((r) {
          return r.parentNavigatorKey == route.navigatorKey;
        }).toList();

        if (matches.isNotEmpty) {
          for (final match in matches) {
            final remap = (
              source: match.navigatorKey,
              destination: route.navigatorKey,
            );

            if (!remapMap.containsKey(remap)) {
              remapMap[remap] = [];
            }
            remapMap[remap]!.add(match);
          }
        }
      }
    }

    final result = <PluggableRouteBase>[];

    for (final route in this) {
      if (route is PluggableShellRoute) {
        final isDestShell = remapMap.keys
            .map((k) => k.destination)
            .any((k) => k == route.navigatorKey);

        final isSourceShell = remapMap.keys
            .map((k) => k.source)
            .any((k) => k == route.navigatorKey);

        if (isDestShell) {
          result.add(
            route.copyWith(
              routes: [
                ...route.routes,
                ...remapMap.entries
                    .where((e) => e.key.destination == route.navigatorKey)
                    .expand((e) => e.value),
              ],
            ),
          );

          continue;
        } else if (isSourceShell) {
          continue;
        }
      }

      result.add(route);
    }

    return result.map((r) => r.asGoRoute).toList();
  }
}

/// Extension on [PluggableRouteBase] to convert Pluggable routes to GoRouter routes.
///
/// This extension provides methods to convert Pluggable route types to their
/// GoRouter equivalents, including:
/// - Regular routes
/// - Shell routes
/// - Page builders
/// - Widget builders
/// - Exit callbacks
/// - Redirect handlers
extension GoRouteConverter on PluggableRouteBase {
  /// Converts a Pluggable route to a GoRouter route.
  ///
  /// Handles both regular routes and shell routes, converting all their
  /// properties and nested routes to the GoRouter format.
  RouteBase get asGoRoute {
    StatefulShellRoute;
    return switch (this) {
      final PluggableRoute r => GoRoute(
          path: r.path,
          name: r.name,
          parentNavigatorKey: parentNavigatorKey,
          builder: r.builder?.asGoRouterWidgetBuilder,
          pageBuilder: switch (r.pageBuilder == null) {
            false => r.pageBuilder!.asGoRouterPageBuilder,
            true => (c, s) {
              return switch (r.pageBuilder) {
                null => null,
                _ => switch (r.transition) {
                  RouteTransition.none => RouteTransitionPage.none(
                    key: s.pageKey,
                    child: r.builder!.asGoRouterWidgetBuilder!(c, s),
                  ),
                  RouteTransition.fade => RouteTransitionPage.fade(
                    key: s.pageKey,
                    child: r.builder!.asGoRouterWidgetBuilder!(c, s),
                  ),
                  RouteTransition.slideUp => RouteTransitionPage.slideUp(
                    key: s.pageKey,
                    child: r.builder!.asGoRouterWidgetBuilder!(c, s),
                  ),
                  RouteTransition.slideDown => RouteTransitionPage.slideDown(
                    key: s.pageKey,
                    child: r.builder!.asGoRouterWidgetBuilder!(c, s),
                  ),
                  RouteTransition.slideLeft => RouteTransitionPage.slideLeft(
                    key: s.pageKey,
                    child: r.builder!.asGoRouterWidgetBuilder!(c, s),
                  ),
                },
              }!;
            }
          },
          onExit: r.onExit?.asGoRouterExitCallback,
          redirect: redirect?.asGoRouterRedirect,
          routes: routes.map((r) => r.asGoRoute).toList(),
        ),
      final PluggableShellRoute r => ShellRoute(
          parentNavigatorKey: parentNavigatorKey,
          navigatorKey: r.navigatorKey,
          builder: r.builder?.asGoRouterShellRouteBuilder,
          pageBuilder: r.pageBuilder?.asGoRouterShellRoutePageBuilder,
          redirect: redirect?.asGoRouterRedirect,
          routes: routes.map((r) => r.asGoRoute).toList(),
        ),
      _ => throw Exception('Invalid route type: $this'),
    };
  }
}

/// Extension on [PluggableRouterPageBuilder] to convert to GoRouter page builders.
extension _PluggableRouterPageBuilderExt on PluggableRouterPageBuilder? {
  /// Converts a Pluggable page builder to a GoRouter page builder.
  ///
  /// Wraps the Pluggable builder to handle the conversion of route state
  /// between the two systems.
  GoRouterPageBuilder? get asGoRouterPageBuilder {
    if (this == null) {
      return null;
    }

    return (context, state) {
      return this!.call(
        context,
        PluggableRouteState(
          route: state.uri,
          params: state.uri.queryParameters,
          pageKey: state.pageKey,
          data: state.extra,
        ),
      );
    };
  }
}

/// Extension on [PluggableRouterWidgetBuilder] to convert to GoRouter widget builders.
extension _PluggableRouterWidgetBuilderExt on PluggableRouterWidgetBuilder? {
  /// Converts a Pluggable widget builder to a GoRouter widget builder.
  ///
  /// Wraps the Pluggable builder to handle the conversion of route state
  /// between the two systems.
  GoRouterWidgetBuilder? get asGoRouterWidgetBuilder {
    if (this == null) {
      return null;
    }

    return (context, state) {
      return this!.call(
        context,
        PluggableRouteState(
          route: state.uri,
          params: state.uri.queryParameters,
          pageKey: state.pageKey,
          data: state.extra,
        ),
      );
    };
  }
}

/// Extension on [PluggableShellRoutePageBuilder] to convert to GoRouter shell route page builders.
extension _PluggableShellRoutePageBuilderExt
    on PluggableShellRoutePageBuilder? {
  /// Converts a Pluggable shell route page builder to a GoRouter shell route page builder.
  ///
  /// Wraps the Pluggable builder to handle the conversion of route state
  /// between the two systems.
  ShellRoutePageBuilder? get asGoRouterShellRoutePageBuilder {
    if (this == null) {
      return null;
    }

    return (context, state, child) {
      return this!.call(
        context,
        PluggableRouteState(
          route: state.uri,
          params: state.uri.queryParameters,
          pageKey: state.pageKey,
          data: state.extra,
        ),
        child,
      );
    };
  }
}

/// Extension on [PluggableShellRouteBuilder] to convert to GoRouter shell route builders.
extension _PluggableShellRouteBuilderExt on PluggableShellRouteBuilder? {
  /// Converts a Pluggable shell route builder to a GoRouter shell route builder.
  ///
  /// Wraps the Pluggable builder to handle the conversion of route state
  /// between the two systems.
  ShellRouteBuilder? get asGoRouterShellRouteBuilder {
    if (this == null) {
      return null;
    }

    return (context, state, child) {
      return this!.call(
        context,
        PluggableRouteState(
          route: state.uri,
          params: state.uri.queryParameters,
          pageKey: state.pageKey,
          data: state.extra,
        ),
        child,
      );
    };
  }
}

/// Extension on [PluggableRouterExitCallback] to convert to GoRouter exit callbacks.
extension _PluggableRouterExitCallbackExt on PluggableRouterExitCallback? {
  /// Converts a Pluggable exit callback to a GoRouter exit callback.
  ///
  /// Wraps the Pluggable callback to handle the conversion of route state
  /// between the two systems.
  ExitCallback? get asGoRouterExitCallback {
    if (this == null) {
      return null;
    }

    return (context, state) {
      return this!.call(
        context,
        PluggableRouteState(
          route: state.uri,
          params: state.uri.queryParameters,
          pageKey: state.pageKey,
          data: state.extra,
        ),
      );
    };
  }
}

/// Extension on [PluggableRouteRedirect] to convert to GoRouter redirect handlers.
extension _PluggableRouteRedirectExt on PluggableRouteRedirect? {
  /// Converts a Pluggable redirect handler to a GoRouter redirect handler.
  ///
  /// Wraps the Pluggable redirect to handle the conversion of route state
  /// between the two systems.
  GoRouterRedirect? get asGoRouterRedirect {
    if (this == null) {
      return null;
    }

    return (context, state) {
      return this!.call(
        context,
        PluggableRouteState(
          route: state.uri,
          params: state.uri.queryParameters,
          pageKey: state.pageKey,
          data: state.extra,
        ),
      );
    };
  }
}
