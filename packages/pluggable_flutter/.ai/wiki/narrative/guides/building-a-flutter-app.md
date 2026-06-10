---
title: Building a Flutter App
category: guide
sources: [lib/src/pluggable_app.dart]
last_updated: 2026-06-10
related: [narrative/modules/app-bootstrap, narrative/concepts/navigation-contract, narrative/concepts/route-model]
covers_packages: [pluggable_flutter]
---

# Building a Flutter App

A Pluggable Flutter app boots through `runPluggableApp`.

## Minimal `main`

```dart
import 'package:pluggable_flutter/pluggable_flutter.dart';
import 'package:go_router_plug/go_router_plug.dart';

void main() {
  runPluggableApp(
    navigationPlugin: GoRouterPlug(initialRoute: '/'),
    modules: [HomeModule()],
    themeBuilder: (ctx) => ThemeData.light(),
  );
}
```

`navigationPlugin` is required; storage/analytics/logging/DI plugs default to the framework's defaults when omitted.

## Declaring routes in a module

Modules contribute framework `PluggableRouteBase` routes (see [[narrative/concepts/route-model]]); the navigator plug renders them. Modules also register their dependencies and mappers through the core module hooks.

## Theming and wrapping

- `themeBuilder` supplies the `MaterialApp` theme.
- `builder` wraps the `MaterialApp.router` (e.g. for global providers or overlays).
- `initCallback` runs after the framework initializes, before `runApp`.

The app rebuilds automatically when the framework notifies listeners (e.g. a module binds/unbinds), because `runPluggableApp` listens on `Pluggable.stream`.

## See Also

- [[narrative/modules/app-bootstrap]] — what `runPluggableApp` does.
- [[narrative/concepts/navigation-contract]] — the navigator API.
- [[narrative/concepts/route-model]] — route types.
