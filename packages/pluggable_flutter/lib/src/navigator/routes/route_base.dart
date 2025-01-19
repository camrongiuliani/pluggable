import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

part 'shell_route.dart';

part 'route_state.dart';

part 'pluggable_route.dart';

/// The signature of the redirect callback.
typedef PluggableRouteRedirect = FutureOr<String?> Function(
  BuildContext context,
  PluggableRouteState state,
);

/// The page builder for [GoRoute].
typedef PluggableRouterPageBuilder = Page<dynamic> Function(
  BuildContext context,
  PluggableRouteState state,
);

/// The widget builder for [GoRoute].
typedef PluggableRouterWidgetBuilder = Widget Function(
  BuildContext context,
  PluggableRouteState state,
);

/// Signature for function used in [PluggableRouteBase.onExit].
typedef PluggableRouterExitCallback = FutureOr<bool> Function(
  BuildContext context,
  PluggableRouteState state,
);

@immutable
abstract class PluggableRouteBase with Diagnosticable {
  const PluggableRouteBase._({
    this.redirect,
    required this.routes,
    required this.parentNavigatorKey,
  });

  final PluggableRouteRedirect? redirect;

  final List<PluggableRouteBase> routes;

  final GlobalKey<NavigatorState>? parentNavigatorKey;

  static Iterable<PluggableRouteBase> routesRecursively(
    Iterable<PluggableRouteBase> routes,
  ) {
    return routes.expand(
      (PluggableRouteBase e) => <PluggableRouteBase>[
        e,
        ...routesRecursively(e.routes),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (parentNavigatorKey != null) {
      properties.add(
        DiagnosticsProperty<GlobalKey<NavigatorState>>(
          'parentNavKey',
          parentNavigatorKey,
        ),
      );
    }
  }
}

abstract class PluggableShellRouteBase extends PluggableRouteBase {
  /// Constructs a [PluggableShellRouteBase].
  const PluggableShellRouteBase._({
    super.redirect,
    required super.routes,
    required super.parentNavigatorKey,
  }) : super._();
}

final RegExp _parameterRegExp = RegExp(r':(\w+)(\((?:\\.|[^\\()])+\))?');

String _escapeGroup(String group, [String? name]) {
  final String escapedGroup = group.replaceFirstMapped(
      RegExp(r'[:=!]'), (Match match) => '\\${match[0]}');
  if (name != null) {
    return '(?<$name>$escapedGroup)';
  }
  return escapedGroup;
}

Map<String, String> extractPathParameters(
  List<String> parameters,
  RegExpMatch match,
) {
  return <String, String>{
    for (int i = 0; i < parameters.length; ++i)
      parameters[i]: match.namedGroup(parameters[i])!
  };
}

RegExp patternToRegExp(String pattern, List<String> parameters) {
  final StringBuffer buffer = StringBuffer('^');
  int start = 0;
  for (final RegExpMatch match in _parameterRegExp.allMatches(pattern)) {
    if (match.start > start) {
      buffer.write(
        RegExp.escape(
          pattern.substring(
            start,
            match.start,
          ),
        ),
      );
    }
    final String name = match[1]!;
    final String? optionalPattern = match[2];
    final String regex = optionalPattern != null
        ? _escapeGroup(optionalPattern, name)
        : '(?<$name>[^/]+)';
    buffer.write(regex);
    parameters.add(name);
    start = match.end;
  }

  if (start < pattern.length) {
    buffer.write(
      RegExp.escape(
        pattern.substring(start),
      ),
    );
  }

  if (!pattern.endsWith('/')) {
    buffer.write(r'(?=/|$)');
  }
  return RegExp(buffer.toString(), caseSensitive: false);
}
