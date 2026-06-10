---
title: Route Model
category: concept
sources: [lib/src/navigator/routes/route_base.dart, lib/src/navigator/custom_transition_page.dart]
last_updated: 2026-06-10
related: [narrative/concepts/navigation-contract, narrative/guides/building-a-flutter-app]
covers_packages: [pluggable_flutter]
---

# Route Model

Routes in a Pluggable Flutter app are expressed as framework-neutral types defined here, not as a specific router's route classes. This keeps modules decoupled from the navigator plug.

## Route types

- `PluggableRouteBase` — the abstract base for all routes (mixes in `Diagnosticable`).
- `PluggableShellRouteBase` — base for shell routes that wrap a sub-navigator (nested navigation, persistent chrome).
- Builder typedefs: `PluggableRouterPageBuilder`, `PluggableRouterWidgetBuilder`, `PluggableShellRouteBuilder`, `PluggableShellRoutePageBuilder`, `PluggableRouteRedirect`, `PluggableRouterExitCallback`, and the `PluggableRouteState` carrying route match state.

## Transitions

`custom_transition_page.dart` and `pluggable_route_transition.dart` provide custom page transitions a route can opt into, independent of the underlying router.

## How they are used

Modules declare these route objects; the active navigator plug converts them to its router's routes when `updateRoutes` runs. For the full type/symbol inventory, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/concepts/navigation-contract]] — `updateRoutes` consumes these types.
- [[narrative/guides/building-a-flutter-app]] — declaring routes in practice.
