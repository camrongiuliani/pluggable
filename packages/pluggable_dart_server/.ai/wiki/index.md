# pluggable_dart_server — Wiki Index

Content catalog. See [overview.md](overview.md) for orientation.

## Overview

[overview.md](overview.md) — two-layer orientation homepage.

## Narrative — Architecture

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/architecture/server-binding]] | How this package binds the core to HTTP servers | `lib/pluggable_dart_server.dart`, `lib/src/pluggable_ext.dart` | binding, layering, re-export, server |

## Narrative — Modules

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/modules/request-handlers]] | `PRequestHandler` lifecycle and `ServerModule` | `lib/src/handler/p_request_handler.dart`, `lib/src/module/server_module.dart` | handler, execute, response, module |

## Narrative — Concepts

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/concepts/request-validation]] | Query/header validation and failure model | `lib/src/validation/` | validation, query, header, exceptions |
| [[narrative/concepts/server-plug-contract]] | The `DartServerPlug` contract | `lib/src/plugs/dart_server_plug.dart` | contract, server, run, handle |

## Narrative — Guides

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/guides/writing-a-handler]] | Implementing a handler with validation | `lib/src/handler/p_request_handler.dart` | guide, handler, get, validate |

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

- `server-binding` ↔ `request-handlers` (binding adds the handler base)
- `server-binding` ↔ `server-plug-contract` (binding owns the contract)
- `request-handlers` ↔ `request-validation` (handler runs validators)
- `request-handlers` ↔ `server-plug-contract` (contract dispatches handlers)
- `request-handlers` ↔ `writing-a-handler` (guide implements a handler)
- `request-validation` ↔ `writing-a-handler`
- `server-plug-contract` ↔ `writing-a-handler`

## Stats

- Narrative pages: 5
- Structure: codesight-generated
- Last updated: 2026-06-10
