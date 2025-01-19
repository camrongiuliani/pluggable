part of 'route_base.dart';

/// The widget builder for [ShellRoute].
typedef PluggableShellRouteBuilder = Widget Function(
  BuildContext context,
  PluggableRouteState state,
  Widget child,
);

/// The page builder for [PluggableShellRoutePageBuilder].
typedef PluggableShellRoutePageBuilder = Page<dynamic> Function(
  BuildContext context,
  PluggableRouteState state,
  Widget child,
);

class PluggableShellRoute extends PluggableShellRouteBase {
  /// Constructs a [PluggableShellRoute].
  PluggableShellRoute({
    required super.routes,
    super.redirect,
    super.parentNavigatorKey,
    this.builder,
    this.pageBuilder,
    this.observers,
    this.restorationScopeId,
    GlobalKey<NavigatorState>? navigatorKey,
  })  : assert(routes.isNotEmpty),
        navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(),
        super._();

  final PluggableShellRouteBuilder? builder;

  final PluggableShellRoutePageBuilder? pageBuilder;

  final List<NavigatorObserver>? observers;

  final GlobalKey<NavigatorState> navigatorKey;

  final String? restorationScopeId;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<GlobalKey<NavigatorState>>(
        'navigatorKey',
        navigatorKey,
      ),
    );
  }
}
