# pluggable_flutter — Overview

`pluggable_flutter` is the Flutter binding of the Pluggable plug-n-play framework. It adapts the framework core to a Flutter app: it provides the `runPluggableApp` entry point, a Flutter-aware `initPluggable`, the `PluggableNavigator` navigation contract, framework-neutral route types, and custom page transitions.

The framework's design is layered: a stack-agnostic core defines plug contracts (DI, storage, logging, mapping, modules); bindings like this one adapt the core to a runtime (Flutter); and plugs supply concrete implementations of contracts. `pluggable_flutter` is the runtime binding for Flutter — it boots the framework, builds a `MaterialApp.router`, and routes through whichever navigator plug the app installs.

This wiki is self-contained: it explains the Flutter entry point, the navigation contract this package owns, the route model, and transitions, without requiring any other package's wiki.

## Narrative layer

- [[narrative/architecture/flutter-binding]] — how this package adapts the core to Flutter and where it sits in the layering.
- [[narrative/modules/app-bootstrap]] — `runPluggableApp` and Flutter `initPluggable`.
- [[narrative/concepts/navigation-contract]] — the `PluggableNavigator` contract this package defines.
- [[narrative/concepts/route-model]] — `PluggableRouteBase`, shell routes, route state, and transitions.
- [[narrative/guides/building-a-flutter-app]] — standing up a Pluggable Flutter app.

## Structure layer

- [structure/README.md](structure/README.md) — generation banner.
- [structure/manifest.json](structure/manifest.json) — machine-readable symbol index.
- [structure/components.md](structure/components.md) / [structure/libraries.md](structure/libraries.md).
- [structure/blast.md](structure/blast.md), [structure/hotspots.md](structure/hotspots.md).

## Which layer answers which question

| Question | Layer |
|---|---|
| "Where is `runPluggableApp`/`PluggableNavigator` defined?" | `structure/manifest.json` |
| "What route types exist?" | `structure/manifest.json` |
| "What does this package depend on?" | `structure/libraries.md` |
| "How does the app boot?" | `narrative/modules/app-bootstrap` |
| "What must a navigator plug implement?" | `narrative/concepts/navigation-contract` |
| "How do I build an app?" | `narrative/guides/building-a-flutter-app` |
