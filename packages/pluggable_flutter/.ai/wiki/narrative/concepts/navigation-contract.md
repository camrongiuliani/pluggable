---
title: Navigation Contract
category: concept
sources: [lib/src/navigator/pluggable_navigator.dart]
last_updated: 2026-06-10
related: [narrative/concepts/route-model, narrative/modules/app-bootstrap]
covers_packages: [pluggable_flutter]
---

# Navigation Contract

This binding defines navigation as an abstract `PluggableNavigator` (a `Plug`). Navigator plugs implement it; app code navigates through it. The contract lives here so the app and its modules never depend on a specific router package.

## The contract

`PluggableNavigator` declares:

- A `RouterConfig<Object> config` and a `GlobalKey<NavigatorState> key` for `MaterialApp.router`.
- `updateRoutes(Iterable<PluggableRouteBase>)` — set the active routes.
- Imperative navigation: `navigate(...)`, pop, `popUntil(predicate)`, `canPop()`, and current-context/route accessors.
- Listener registration (`addListener` / `removeListener`) for route-change notification.

## Who implements it

A navigator plug supplies the concrete router. In this monorepo, `go_router_plug` implements `PluggableNavigator` over `go_router` and converts `PluggableRouteBase` routes (see [[narrative/concepts/route-model]]) into its router's route type. Any conforming implementation can be installed instead.

For exact symbols, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/concepts/route-model]] — the route types passed to `updateRoutes`.
- [[narrative/modules/app-bootstrap]] — installs the navigator and wires routes.
