# pluggable_flutter — Wiki Index

Content catalog. See [overview.md](overview.md) for orientation.

## Overview

[overview.md](overview.md) — two-layer orientation homepage.

## Narrative — Architecture

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/architecture/flutter-binding]] | How this package binds the core to Flutter | `lib/pluggable_flutter.dart`, `lib/src/pluggable_ext.dart` | binding, layering, re-export, flutter |

## Narrative — Modules

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/modules/app-bootstrap]] | `runPluggableApp` and Flutter `initPluggable` | `lib/src/pluggable_app.dart`, `lib/src/pluggable_ext.dart` | bootstrap, runApp, MaterialApp, init |

## Narrative — Concepts

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/concepts/navigation-contract]] | The `PluggableNavigator` contract | `lib/src/navigator/pluggable_navigator.dart` | navigation, contract, router, navigator |
| [[narrative/concepts/route-model]] | `PluggableRouteBase`, shell routes, transitions | `lib/src/navigator/routes/` | routes, shell, transition, route-state |

## Narrative — Guides

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/guides/building-a-flutter-app]] | Standing up a Pluggable Flutter app | `lib/src/pluggable_app.dart` | guide, main, theme, modules |

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

- `flutter-binding` ↔ `app-bootstrap` (binding adds the entry point)
- `flutter-binding` ↔ `navigation-contract` (binding owns the contract)
- `app-bootstrap` ↔ `navigation-contract` (installs the navigator)
- `app-bootstrap` ↔ `building-a-flutter-app` (guide uses the entry point)
- `navigation-contract` ↔ `route-model` (`updateRoutes` consumes route types)
- `navigation-contract` ↔ `building-a-flutter-app`
- `route-model` ↔ `building-a-flutter-app`

## Stats

- Narrative pages: 5
- Structure: codesight-generated
- Last updated: 2026-06-10
