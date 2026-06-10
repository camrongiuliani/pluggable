---
title: Navigator Contract
category: concept
sources: [lib/go_router_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/go-router-plug, narrative/guides/using-the-navigator]
covers_packages: [go_router_plug]
---

# Navigator Contract

The Flutter binding defines navigation as an abstract `PluggableNavigator` (a `Plug`). `GoRouterPlug` implements this contract, which is why the routing backend is interchangeable behind a single navigation API.

## The contract

`PluggableNavigator` declares:

- A `RouterConfig<Object> config` and a `GlobalKey<NavigatorState> key` for wiring into `MaterialApp.router`.
- `updateRoutes(Iterable<PluggableRouteBase>)` — replace the active route set.
- Imperative navigation: `navigate(...)` (with query params), pop, `popUntil(predicate)`, `canPop()`.
- Current-context / current-route accessors.
- Listener registration (`addListener` / `removeListener`) for route-change notifications.

Routes are expressed as framework-neutral `PluggableRouteBase` objects so module authors do not couple to a specific router. The active plug converts them to its backend's route type — see [[narrative/concepts/route-conversion]].

## How `GoRouterPlug` fulfils it

`GoRouterPlug` backs every operation with a `go_router` `GoRouter` and a `ValueNotifier<RoutingConfig>`. `config` returns the `GoRouter`; navigation calls delegate to `GoRouter`/`BuildContext` extensions.

## See Also

- [[narrative/modules/go-router-plug]] — the implementing class.
- [[narrative/concepts/route-conversion]] — route translation.
