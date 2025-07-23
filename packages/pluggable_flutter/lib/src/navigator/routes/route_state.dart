
part of 'route_base.dart';

class PluggableRouteState {
  final Uri route;
  final String matchedLocation;
  final Map<String, String> params;
  final Object? data;
  final ValueKey<String> pageKey;

  PluggableRouteState({
    required this.route,
    required this.matchedLocation,
    required this.params,
    required this.pageKey,
    this.data,
  });

  @override
  String toString() {
    return 'PluggableRouteState(route: $route, matchedLocation: $matchedLocation, params: $params, data: $data)';
  }
}