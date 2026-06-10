# Pluggable Monorepo — Root Wiki Index (Umbrella)

Top-level catalog for the `plugg` monorepo. See [overview.md](overview.md) for orientation. This umbrella links DOWN to 13 standalone package wikis; it documents no package internals.

## Overview

[overview.md](overview.md) — architecture and downward links to every package wiki.

## Narrative — Architecture

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/architecture/layering]] | The core → bindings → plugs layering and dependency direction | `packages/pluggable`, `packages/pluggable_flutter`, `packages/pluggable_dart_server` | layering, core, binding, plug |
| [[narrative/architecture/plug-catalog]] | Contract-to-plug mapping and defaults | `packages/pluggable` | catalog, contract, default, plug |

## Narrative — Guides

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/guides/choosing-plugs]] | Selecting plugs when assembling an app | `packages/pluggable` | guide, storage, logger, selection |

## Package Wikis (downward links)

| Wiki | Layer | Overview |
|---|---|---|
| pluggable | core | [overview](../../packages/pluggable/.ai/wiki/overview.md) |
| pluggable_flutter | binding | [overview](../../packages/pluggable_flutter/.ai/wiki/overview.md) |
| pluggable_dart_server | binding | [overview](../../packages/pluggable_dart_server/.ai/wiki/overview.md) |
| pluggable_di_getit | plug (DI) | [overview](../../packages/plugs/di/pluggable_di_getit/.ai/wiki/overview.md) |
| datadog_logger_plug | plug (logger) | [overview](../../packages/plugs/logger/datadog_logger_plug/.ai/wiki/overview.md) |
| cartographer_mapper_plug | plug (mapper) | [overview](../../packages/plugs/mapper/cartographer_mapper_plug/.ai/wiki/overview.md) |
| go_router_plug | plug (navigator) | [overview](../../packages/plugs/navigator/go_router_plug/.ai/wiki/overview.md) |
| dart_frog_server_plug | plug (server) | [overview](../../packages/plugs/server/dart_frog_server_plug/.ai/wiki/overview.md) |
| expire_cache_storage_plug | plug (storage) | [overview](../../packages/plugs/storage/expire_cache_storage_plug/.ai/wiki/overview.md) |
| in_memory_storage_plug | plug (storage) | [overview](../../packages/plugs/storage/in_memory_storage_plug/.ai/wiki/overview.md) |
| object_box_storage_plug | plug (storage) | [overview](../../packages/plugs/storage/object_box_storage_plug/.ai/wiki/overview.md) |
| redis_storage_plug | plug (storage) | [overview](../../packages/plugs/storage/redis_storage_plug/.ai/wiki/overview.md) |
| secure_storage_plug | plug (storage) | [overview](../../packages/plugs/storage/secure_storage_plug/.ai/wiki/overview.md) |

## Structure Layer

Intentionally absent — the repo root has no code. Each package wiki carries its own codesight `structure/` layer.

## Page Relationships

- `layering` ↔ `plug-catalog` (catalog instantiates the layering)
- `layering` ↔ `choosing-plugs` (selection follows the layering)
- `plug-catalog` ↔ `choosing-plugs` (guide uses the catalog)

## Stats

- Narrative pages: 3
- Package wikis linked: 13
- Structure: intentionally absent (documentation-only umbrella)
- Last updated: 2026-06-10
