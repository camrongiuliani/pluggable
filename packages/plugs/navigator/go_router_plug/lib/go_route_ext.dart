import 'package:pluggable_flutter/pluggable_flutter.dart';
import 'package:go_router/go_router.dart';

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
    return switch (this) {
      final PluggableRoute r => GoRoute(
          path: r.path,
          name: r.name,
          parentNavigatorKey: parentNavigatorKey,
          builder: r.builder?.asGoRouterWidgetBuilder,
          pageBuilder: r.pageBuilder?.asGoRouterPageBuilder,
          onExit: r.onExit?.asGoRouterExitCallback,
          redirect: redirect?.asGoRouterRedirect,
          routes: routes.map((r) => r.asGoRoute).toList(),
        ),
      final PluggableShellRoute r => ShellRoute(
          parentNavigatorKey: parentNavigatorKey,
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
