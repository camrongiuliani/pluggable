---
title: GoRouterPlug
category: module
sources: [lib/go_router_plug.dart]
last_updated: 2026-06-10
related: [narrative/concepts/navigator-contract, narrative/concepts/route-conversion, narrative/guides/using-the-navigator]
covers_packages: [go_router_plug]
---

# GoRouterPlug

`GoRouterPlug` is the navigator implementation of this package. It extends `PluggableNavigator` and wraps a `go_router` `GoRouter`, exposing the framework's navigation contract while delegating routing to `go_router`.

## Role

The Flutter binding models navigation as a swappable `PluggableNavigator` contract. `GoRouterPlug` is one implementation; an app passes it as `navigationPlugin` at launch, and modules/screens navigate through the abstract contract (`Pluggable`-managed navigator), never touching `go_router` directly.

## Construction and config

- Constructed with a required `initialRoute` and an optional `rootNavigatorKey`. When no key is supplied it creates a `GlobalKey<NavigatorState>` labelled `GoRouterPlug`.
- Holds a `ValueNotifier<RoutingConfig>` whose route list is updated as modules register routes.
- `config` exposes the underlying `GoRouter` as a `RouterConfig<Object>` for `MaterialApp.router`.

## Behavior

- `init` builds the `GoRouter` from the routing config, navigator key, observers, initial location, and error handling.
- `updateRoutes` rebuilds the routing config from a set of `PluggableRouteBase` routes (converted via `asGoRoutes` — see [[narrative/concepts/route-conversion]]).
- Navigation methods (`navigate`, pop, `popUntil`, `canPop`, current context/route accessors) map onto `go_router`/`GoRouter` operations, including query-parameter handling.

For the full method inventory, see [structure/manifest.json](../../structure/manifest.json). The contract types are defined by the Flutter binding (`pluggable_flutter`).

## See Also

- [[narrative/concepts/navigator-contract]] — the contract this class implements.
- [[narrative/concepts/route-conversion]] — the `asGoRoutes` bridge.
- [[narrative/guides/using-the-navigator]] — installing and navigating.
