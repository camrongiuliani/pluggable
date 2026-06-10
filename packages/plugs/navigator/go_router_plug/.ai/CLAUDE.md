# go_router_plug — Wiki Schema

Wiki schema for the `go_router_plug` package: a **navigator plug** for the Pluggable plug-n-play framework's Flutter binding. It implements the framework's `PluggableNavigator` contract on top of the [`go_router`](https://pub.dev/packages/go_router) package.

This wiki is **standalone** — it documents this package completely without requiring any other wiki. Cross-package references appear only as optional "see also" links.

## Domain

`go_router_plug` exposes `GoRouterPlug` (the navigator implementation) and a `GoRouteListConverter` extension that translates the framework's `PluggableRouteBase` routes into `go_router` `RouteBase` routes. It provides routing, navigation (push/pop/navigate), query-parameter handling, and shell-route support for Pluggable Flutter apps.

## Relationship to other wikis

- **Implements a contract owned by the Flutter binding** (`pluggable_flutter`): `PluggableNavigator`, `PluggableRouteBase`, `PluggableShellRoute`, and the route-builder typedefs are defined there. This wiki documents the implementation; the contract is covered by the `pluggable_flutter` wiki (see "see also" links).
- No wiki depends on this one. It is a leaf.

## Architecture (the four wiki elements)

- `wiki/narrative/` — module intent, the navigator contract, route conversion, and a usage guide.
- `wiki/structure/` — codesight-generated inventory. Never hand-edited.
- `wiki/index.md`, `wiki/overview.md`, `wiki/log.md`.

## Directory layout

```
.ai/wiki/
├── narrative/{modules,concepts,guides}/
├── structure/
├── index.md
├── overview.md
└── log.md
```

## Codebase context

- `lib/go_router_plug.dart` — `GoRouterPlug` (extends `PluggableNavigator`).
- `lib/go_route_ext.dart` — `GoRouteListConverter` extension (`asGoRoutes`) + `Remap` typedef.
- Depends on `go_router`, `collection`, `pluggable_flutter`, Flutter SDK.

## Page conventions

- Frontmatter on every narrative page; `[[narrative/...]]` for in-wiki links, markdown links into `structure/`.
- Narrative = intent and design; exhaustive symbol inventory lives in `structure/`.

## Current-state discipline

Narrative pages describe the package as it is now. Change history belongs in `log.md` only.

## Session start protocol

1. Read this schema.
2. Read `wiki/overview.md`.
3. "Where is X / what exists" → `structure/manifest.json`; "why / how" → `narrative/`.
