part of 'route_base.dart';

class PluggableRoute extends PluggableRouteBase {
  /// Constructs a [GoRoute].
  /// - [path] and [name] cannot be empty strings.
  /// - One of either [builder] or [pageBuilder] must be provided.
  PluggableRoute({
    required this.path,
    this.name,
    this.builder,
    this.pageBuilder,
    super.parentNavigatorKey,
    super.redirect,
    this.onExit,
    super.routes = const <PluggableRouteBase>[],
  })  : assert(
          path.isNotEmpty,
          'Route path cannot be empty',
        ),
        assert(
          name == null || name.isNotEmpty,
          'Route name cannot be empty',
        ),
        assert(
          pageBuilder != null || builder != null || redirect != null,
          'builder, pageBuilder, or redirect must be provided',
        ),
        assert(
          onExit == null || pageBuilder != null || builder != null,
          'if onExit is provided, one of pageBuilder or builder must be provided',
        ),
        super._() {
    // cache the path regexp and parameters
    _pathRE = patternToRegExp(path, pathParameters);
  }

  late final RegExp _pathRE;

  bool get redirectOnly => pageBuilder == null && builder == null;

  final String? name;

  final String path;

  final PluggableRouterPageBuilder? pageBuilder;

  final PluggableRouterWidgetBuilder? builder;

  final PluggableRouterExitCallback? onExit;

  RegExpMatch? matchPatternAsPrefix(String loc) {
    return _pathRE.matchAsPrefix('/$loc') as RegExpMatch? ??
        _pathRE.matchAsPrefix(loc) as RegExpMatch?;
  }

  /// Extract the path parameters from a match.
  Map<String, String> extractPathParams(
    RegExpMatch match,
  ) =>
      extractPathParameters(
        pathParameters,
        match,
      );

  final List<String> pathParameters = <String>[];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(
      StringProperty(
        'name',
        name,
      ),
    );
    properties.add(
      StringProperty(
        'path',
        path,
      ),
    );
    properties.add(
      FlagProperty(
        'redirect',
        value: redirectOnly,
        ifTrue: 'Redirect Only',
      ),
    );
  }
}
