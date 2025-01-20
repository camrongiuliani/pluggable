import 'package:pluggable_flutter/pluggable_flutter.dart';
import 'package:go_router/go_router.dart';

extension GoRouteConverter on PluggableRouteBase {
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

extension _PluggableRouterPageBuilderExt on PluggableRouterPageBuilder? {
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

extension _PluggableRouterWidgetBuilderExt on PluggableRouterWidgetBuilder? {
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

extension _PluggableShellRoutePageBuilderExt
    on PluggableShellRoutePageBuilder? {
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

extension _PluggableShellRouteBuilderExt on PluggableShellRouteBuilder? {
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

extension _PluggableRouterExitCallbackExt on PluggableRouterExitCallback? {
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

extension _PluggableRouteRedirectExt on PluggableRouteRedirect? {
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
