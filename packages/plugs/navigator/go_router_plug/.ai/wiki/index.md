# go_router_plug — Wiki Index

Content catalog. See [overview.md](overview.md) for orientation.

## Overview

[overview.md](overview.md) — two-layer orientation homepage.

## Narrative — Modules

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/modules/go-router-plug]] | The `GoRouterPlug` navigator class | `lib/go_router_plug.dart` | navigator, go_router, plug, routing |

## Narrative — Concepts

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/concepts/navigator-contract]] | The `PluggableNavigator` contract | `lib/go_router_plug.dart` | contract, navigation, routes, navigator |
| [[narrative/concepts/route-conversion]] | `asGoRoutes` translation of `PluggableRouteBase` to `go_router` | `lib/go_route_ext.dart` | routes, conversion, shell, remap |

## Narrative — Guides

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/guides/using-the-navigator]] | Installing the navigator and navigating | `lib/go_router_plug.dart` | guide, install, navigate, routes |

## Structure Layer

| File | Content |
|---|---|
| [structure/README.md](structure/README.md) | Generation banner + regeneration command |
| [structure/routes.md](structure/routes.md) | Routes |
| [structure/models.md](structure/models.md) | Models |
| [structure/components.md](structure/components.md) | UI components |
| [structure/blast.md](structure/blast.md) | High-impact files |
| [structure/hotspots.md](structure/hotspots.md) | Entry points, config |
| [structure/libraries.md](structure/libraries.md) | Dependency inventory |
| [structure/manifest.json](structure/manifest.json) | Machine-readable symbol index |

## Page Relationships

- `go-router-plug` ↔ `navigator-contract` (class implements the contract)
- `go-router-plug` ↔ `route-conversion` (`updateRoutes` calls `asGoRoutes`)
- `go-router-plug` ↔ `using-the-navigator` (guide uses the class)
- `navigator-contract` ↔ `route-conversion` (routes are framework-neutral)
- `navigator-contract` ↔ `using-the-navigator`
- `route-conversion` ↔ `using-the-navigator`

## Stats

- Narrative pages: 4
- Structure: codesight-generated
- Last updated: 2026-06-10
