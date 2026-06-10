---
title: App Bootstrap
category: module
sources: [lib/src/pluggable_app.dart, lib/src/pluggable_ext.dart]
last_updated: 2026-06-10
related: [narrative/architecture/flutter-binding, narrative/concepts/navigation-contract, narrative/guides/building-a-flutter-app]
covers_packages: [pluggable_flutter]
---

# App Bootstrap

This binding provides the top-level entry point for a Pluggable Flutter app: `runPluggableApp`, backed by a Flutter-aware `initPluggable`.

## `runPluggableApp`

`runPluggableApp` is the single call an app's `main` makes. It:

1. Calls the Flutter `initPluggable` with the supplied plugs and modules.
2. Awaits an optional `initCallback` for app-specific startup work.
3. Calls `runApp` with a `StreamBuilder` listening on `Pluggable.stream`, rebuilding a `MaterialApp.router` whose `routerConfig` is `Pluggable.navigator.config`.

Required parameter: `navigationPlugin` (a `PluggableNavigator`). Optional: `modules`, `storagePlugin`, `analyticsPlugin`, `loggingPlugin`, `diPlugin`, `initCallback`, `themeBuilder`, and an outer `builder` for wrapping the `MaterialApp`.

## Flutter `initPluggable`

`pluggable_ext.dart` defines a Flutter-specific `initPluggable` that installs the navigator plug alongside the core plugs and wires module-contributed routes into the navigator. It shadows the core `initPluggable` (which the barrel hides) so Flutter apps get navigation set up automatically.

For exact signatures and typedefs (`ThemeBuilder`, `CustomBuilder`, `InitCallback`), see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/architecture/flutter-binding]] — where bootstrap sits in the layering.
- [[narrative/concepts/navigation-contract]] — the navigator wired in here.
- [[narrative/guides/building-a-flutter-app]] — a worked setup.
