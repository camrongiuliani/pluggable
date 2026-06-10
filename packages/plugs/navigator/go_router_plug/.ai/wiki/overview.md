# go_router_plug — Overview

`go_router_plug` is the navigator plug for the Pluggable plug-n-play framework's Flutter binding. It implements the framework's `PluggableNavigator` contract using the [`go_router`](https://pub.dev/packages/go_router) package, providing declarative routing, imperative navigation, query parameters, and shell routes.

A "plug" satisfies an abstract contract so it can be swapped without changing application code. `GoRouterPlug` is supplied as the `navigationPlugin` when launching a Pluggable Flutter app; modules contribute routes as framework `PluggableRouteBase` objects, and this plug converts them to `go_router` routes via the `asGoRoutes` extension.

This wiki is self-contained: it explains the plug, the navigator contract it satisfies, and the route-conversion bridge, without requiring any other package's wiki.

## Narrative layer

- [[narrative/modules/go-router-plug]] — the `GoRouterPlug` class and its `go_router` mapping.
- [[narrative/concepts/navigator-contract]] — the `PluggableNavigator` contract this plug satisfies.
- [[narrative/concepts/route-conversion]] — how `PluggableRouteBase` routes become `go_router` routes (`asGoRoutes`).
- [[narrative/guides/using-the-navigator]] — installing the plug and navigating.

## Structure layer

- [structure/README.md](structure/README.md) — generation banner.
- [structure/manifest.json](structure/manifest.json) — machine-readable symbol index.
- [structure/libraries.md](structure/libraries.md) — dependency inventory.
- [structure/blast.md](structure/blast.md), [structure/hotspots.md](structure/hotspots.md).

## Which layer answers which question

| Question | Layer |
|---|---|
| "Where is `navigate`/`asGoRoutes` defined?" | `structure/manifest.json` |
| "What does this plug depend on?" | `structure/libraries.md` |
| "What navigation operations exist?" | `narrative/concepts/navigator-contract` |
| "How are routes converted?" | `narrative/concepts/route-conversion` |
| "How do I install the navigator?" | `narrative/guides/using-the-navigator` |
