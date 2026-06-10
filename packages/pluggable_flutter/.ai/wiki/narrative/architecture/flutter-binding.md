---
title: Flutter Binding
category: architecture
sources: [lib/pluggable_flutter.dart, lib/src/pluggable_ext.dart]
last_updated: 2026-06-10
related: [narrative/modules/app-bootstrap, narrative/concepts/navigation-contract]
covers_packages: [pluggable_flutter]
---

# Flutter Binding

`pluggable_flutter` is a binding: it adapts the stack-agnostic Pluggable core to the Flutter runtime. It does not redefine the core's plug system — it re-exports the core and layers Flutter-specific entry points and contracts on top.

## Layering

- **Core** (`pluggable`) defines the plug contracts (DI, storage, logging, mapping) and the module/plug lifecycle, with no UI or runtime assumptions.
- **This binding** adds a Flutter entry point (`runPluggableApp`), a Flutter `initPluggable` that also installs a navigator, the `PluggableNavigator` navigation contract, and Flutter route/transition types.
- **Navigator plugs** (e.g. `go_router_plug`) implement `PluggableNavigator` with a concrete router.

## Re-export strategy

The barrel `pluggable_flutter.dart` re-exports the core via `export 'package:pluggable/pluggable.dart' hide initPluggable;` — so app code gets the entire core API plus Flutter additions from a single import, while this package's Flutter-aware `initPluggable` shadows the core one. It also re-exports the navigator, route types, and transition types.

## See Also

- [[narrative/modules/app-bootstrap]] — the entry point this binding adds.
- [[narrative/concepts/navigation-contract]] — the contract this binding owns.
