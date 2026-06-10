# pluggable — Wiki Index

Content catalog for the framework core. See [overview.md](overview.md) for orientation.

## Overview

[overview.md](overview.md) — two-layer orientation homepage.

## Narrative — Architecture

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/architecture/plug-system]] | What a plug is; contracts vs implementations | `lib/src/plug.dart` | plug, contract, swappable, architecture |

## Narrative — Modules

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/modules/pluggable-runtime]] | `PluggableImpl`, `Pluggable`, `initPluggable`, events | `lib/src/pluggable/pluggable.dart` | runtime, init, singleton, event-bus |
| [[narrative/modules/pluggable-module]] | Modules: scoped binding, dep/mapper registration | `lib/src/module/pluggable_module.dart` | module, bind, scope, lifecycle |

## Narrative — Concepts

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/concepts/di-contract]] | The `PluggableDI` contract and scopes | `lib/src/di/pluggable_di.dart` | di, scope, singleton, contract |
| [[narrative/concepts/storage-contract]] | `PluggableStorage`/`PluggableStorageProvider` | `lib/src/storage/` | storage, provider, decoder, in-flight |
| [[narrative/concepts/logger-and-analytics]] | `PluggableLogger`, `PluggableAnalytics`, `PluggableEnv` | `lib/src/logger/`, `lib/src/analytics/`, `lib/src/env/` | logger, analytics, env, defaults |
| [[narrative/concepts/mapper-and-http]] | `PluggableMapper` and HTTP models | `lib/src/mapper/`, `lib/src/http/` | mapper, http, request, response |

## Structure Layer

| File | Content |
|---|---|
| [structure/README.md](structure/README.md) | Generation banner + regeneration command |
| [structure/routes.md](structure/routes.md) | Routes (n/a) |
| [structure/models.md](structure/models.md) | Models (HTTP request/response models) |
| [structure/components.md](structure/components.md) | UI components (n/a) |
| [structure/blast.md](structure/blast.md) | High-impact files |
| [structure/hotspots.md](structure/hotspots.md) | Entry points, config |
| [structure/libraries.md](structure/libraries.md) | Dependency inventory |
| [structure/manifest.json](structure/manifest.json) | Machine-readable symbol index |

## Page Relationships

- `plug-system` ↔ `pluggable-runtime` (runtime holds plugs)
- `plug-system` ↔ `pluggable-module` (module is a plug)
- `plug-system` ↔ `di-contract` (DI is a contract)
- `pluggable-runtime` ↔ `pluggable-module` (runtime initializes modules)
- `pluggable-runtime` ↔ `logger-and-analytics` (installs defaults)
- `pluggable-module` ↔ `di-contract` (scopes for isolation)
- `pluggable-module` ↔ `mapper-and-http` (registers mappers)
- `storage-contract` ↔ `plug-system`, `pluggable-runtime`
- `mapper-and-http` ↔ `plug-system`

## Stats

- Narrative pages: 7
- Structure: codesight-generated
- Last updated: 2026-06-10
