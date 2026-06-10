# pluggable_flutter — Wiki Schema

Wiki schema for the `pluggable_flutter` package: the **Flutter binding** of the Pluggable plug-n-play framework. It adapts the framework core to Flutter — wiring `initPluggable` into a `MaterialApp.router`, defining the navigation contract, and providing route/transition abstractions.

This wiki is **standalone** — it documents this package completely without requiring any other wiki. Cross-package references appear only as optional "see also" links.

## Domain

`pluggable_flutter` provides the entry point `runPluggableApp` plus a Flutter-aware `initPluggable`, the `PluggableNavigator` navigation contract, framework-neutral route types (`PluggableRouteBase`, shell routes, route state), and custom page transitions. Application modules register routes as `PluggableRouteBase` objects; a navigator plug (e.g. `go_router_plug`) renders them.

## Relationship to other wikis

- **Builds on the framework core** (`pluggable`): re-exports the core (hiding the core `initPluggable`) and adds Flutter-specific bindings. The core abstractions (`Plug`, `PluggableModule`, DI/storage/logger/mapper) are documented by the `pluggable` wiki.
- **Owns the contract** that navigator plugs implement: `go_router_plug` implements `PluggableNavigator` defined here.
- These appear only as "see also" links. No wiki depends on this one.

## Architecture (the four wiki elements)

- `wiki/narrative/` — app bootstrap, navigation contract, route model, transitions.
- `wiki/structure/` — codesight-generated inventory. Never hand-edited.
- `wiki/index.md`, `wiki/overview.md`, `wiki/log.md`.

## Directory layout

```
.ai/wiki/
├── narrative/{architecture,modules,concepts,guides}/
├── structure/
├── index.md
├── overview.md
└── log.md
```

## Codebase context

- `lib/src/pluggable_app.dart` — `runPluggableApp` entry point + `ThemeBuilder`/`CustomBuilder`/`InitCallback` typedefs.
- `lib/src/pluggable_ext.dart` — Flutter `initPluggable` (registers the navigator plug, wires routes).
- `lib/src/navigator/pluggable_navigator.dart` — `PluggableNavigator` contract.
- `lib/src/navigator/routes/` — `PluggableRouteBase`, shell routes, route state, builder typedefs.
- `lib/src/navigator/custom_transition_page.dart`, `pluggable_route_transition.dart` — transitions.
- Depends on Flutter SDK, `pluggable`, `pluggable_di_getit`, `collection`.

## Page conventions

- Frontmatter on every narrative page; `[[narrative/...]]` for in-wiki links, markdown links into `structure/`.
- Narrative = intent and design; exhaustive symbol inventory lives in `structure/`.

## Current-state discipline

Narrative pages describe the package as it is now. Change history belongs in `log.md` only.

## Session start protocol

1. Read this schema.
2. Read `wiki/overview.md`.
3. "Where is X / what exists" → `structure/manifest.json`; "why / how" → `narrative/`.
