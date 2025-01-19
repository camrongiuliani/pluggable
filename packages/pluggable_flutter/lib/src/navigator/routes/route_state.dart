
part of 'route_base.dart';

class PluggableRouteState {
  final Uri route;
  final Map<String, String> params;
  final Object? data;
  final ValueKey<String> pageKey;

  PluggableRouteState({
    required this.route,
    required this.params,
    required this.pageKey,
    this.data,
  });

  @override
  String toString() {
    return 'PluggableRouteState(route: $route, params: $params, data: $data)';
  }
}