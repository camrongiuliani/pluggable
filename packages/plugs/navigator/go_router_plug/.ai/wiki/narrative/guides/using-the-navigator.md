---
title: Using the Navigator
category: guide
sources: [lib/go_router_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/go-router-plug, narrative/concepts/navigator-contract, narrative/concepts/route-conversion]
covers_packages: [go_router_plug]
---

# Using the Navigator

`GoRouterPlug` is supplied as the navigation plug when launching a Pluggable Flutter app.

## Installing

```dart
void main() {
  runPluggableApp(
    navigationPlugin: GoRouterPlug(initialRoute: '/'),
    modules: [MyModule()],
  );
}
```

Optionally pass a `rootNavigatorKey` to share a navigator key with the rest of the app.

## Declaring routes

Modules declare framework `PluggableRouteBase` routes (plain routes and shell routes). The plug converts them to `go_router` routes automatically via `asGoRoutes` when `updateRoutes` runs — see [[narrative/concepts/route-conversion]]. You do not write `go_router` `GoRoute`s by hand.

## Navigating

Navigate through the framework's navigator API rather than `go_router` directly:

```dart
navigator.navigate('/profile', queryParams: {'id': '123'});
if (navigator.canPop()) navigator.pop();
navigator.popUntil((route) => route.isFirst);
```

This keeps screens decoupled from `go_router`, so the navigator plug can be swapped without rewriting navigation calls.

## See Also

- [[narrative/modules/go-router-plug]] — construction and config.
- [[narrative/concepts/navigator-contract]] — the full operation set.
- [[narrative/concepts/route-conversion]] — how routes are translated.
