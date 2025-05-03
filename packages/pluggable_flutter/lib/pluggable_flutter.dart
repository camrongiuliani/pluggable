/// A Flutter-specific implementation of the Pluggable framework.
///
/// This package provides Flutter-specific extensions and implementations
/// for the Pluggable framework, including:
/// - Navigation system
/// - Route management
/// - Custom transitions
/// - Flutter-specific module support
///
/// Example usage:
/// ```dart
/// import 'package:pluggable_flutter/pluggable_flutter.dart';
///
/// void main() {
///   runPluggableApp(
///     navigationPlugin: GoRouterPlug(initialRoute: '/'),
///     modules: [MyModule()],
///   );
/// }
/// ```
export 'src/pluggable_app.dart';
export 'src/pluggable_ext.dart';
export 'package:pluggable/pluggable.dart' hide initPluggable;
export 'src/navigator/pluggable_route_transition.dart';
export 'src/navigator/pluggable_navigator.dart';
export 'src/navigator/pluggable_route.dart';
export 'src/navigator/routes/route_base.dart'
    show
    PluggableRouteState,
    PluggableRouterPageBuilder,
    PluggableRouterWidgetBuilder,
    PluggableShellRouteBuilder,
    PluggableShellRoutePageBuilder,
    PluggableRouteRedirect,
    PluggableRouteBase,
    PluggableRouterExitCallback;
