---
title: Route Conversion
category: concept
sources: [lib/go_route_ext.dart]
last_updated: 2026-06-10
related: [narrative/modules/go-router-plug, narrative/concepts/navigator-contract]
covers_packages: [go_router_plug]
---

# Route Conversion

Modules declare routes as framework-neutral `PluggableRouteBase` objects. `GoRouterPlug` cannot hand those directly to `go_router`, so the package provides a `GoRouteListConverter` extension that translates them into `go_router` `RouteBase` objects.

## `asGoRoutes`

`GoRouteListConverter` adds `asGoRoutes` to `Iterable<PluggableRouteBase>`. It walks the route list and produces the matching `go_router` route tree:

- Plain `PluggableRoute`s become `GoRoute`s, wiring through their page/widget builders and redirects.
- `PluggableShellRoute`s become shell routes; the extension reconciles parent/child navigator keys using an internal `Remap` record (`{source, destination}` navigator-key pair) so nested shells attach to the correct navigator.

The framework's route-builder typedefs (page builder, widget builder, shell builders, redirect, exit callback) are adapted to their `go_router` equivalents during conversion.

## Where it is used

`GoRouterPlug.updateRoutes` calls `asGoRoutes` to rebuild its `RoutingConfig` whenever the active route set changes (e.g. as modules bind/unbind). This keeps the framework's route model and `go_router`'s configuration in sync.

For exact symbols, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/modules/go-router-plug]] — calls `asGoRoutes` from `updateRoutes`.
- [[narrative/concepts/navigator-contract]] — why routes are framework-neutral.
