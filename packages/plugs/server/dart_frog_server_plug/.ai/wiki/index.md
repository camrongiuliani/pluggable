# dart_frog_server_plug — Wiki Index

Content catalog. See [overview.md](overview.md) for orientation.

## Overview

[overview.md](overview.md) — two-layer orientation homepage.

## Narrative — Modules

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/modules/dart-frog-server-plug]] | The `DartFrogServerPlug` server class | `lib/dart_frog_server_plug.dart` | server, dart_frog, plug, http |

## Narrative — Concepts

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/concepts/server-contract]] | The `DartServerPlug` contract | `lib/dart_frog_server_plug.dart` | contract, server, run, handle |
| [[narrative/concepts/request-response-mapping]] | Mapping `RequestContext`/`Response` to neutral types | `lib/mappers/` | mapper, request, response, formdata |

## Narrative — Guides

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/guides/running-the-server]] | Constructing, starting, and serving requests | `lib/dart_frog_server_plug.dart` | guide, run, serve, mount |

## Structure Layer

| File | Content |
|---|---|
| [structure/README.md](structure/README.md) | Generation banner + regeneration command |
| [structure/routes.md](structure/routes.md) | Routes |
| [structure/models.md](structure/models.md) | Models |
| [structure/components.md](structure/components.md) | UI components (n/a) |
| [structure/blast.md](structure/blast.md) | High-impact files |
| [structure/hotspots.md](structure/hotspots.md) | Entry points, config |
| [structure/libraries.md](structure/libraries.md) | Dependency inventory |
| [structure/manifest.json](structure/manifest.json) | Machine-readable symbol index |

## Page Relationships

- `dart-frog-server-plug` ↔ `server-contract` (class implements the contract)
- `dart-frog-server-plug` ↔ `request-response-mapping` (`init`/`handle` use mappers)
- `dart-frog-server-plug` ↔ `running-the-server` (guide uses the class)
- `server-contract` ↔ `request-response-mapping` (neutral types)
- `server-contract` ↔ `running-the-server`
- `request-response-mapping` ↔ `running-the-server`

## Stats

- Narrative pages: 4
- Structure: codesight-generated
- Last updated: 2026-06-10
