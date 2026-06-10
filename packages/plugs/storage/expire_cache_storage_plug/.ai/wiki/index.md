# expire_cache_storage_plug — Wiki Index

Content catalog for the `expire_cache_storage_plug` wiki. See [overview.md](overview.md) for orientation.

## Overview

[overview.md](overview.md) — two-layer orientation homepage.

## Narrative — Modules

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/modules/expire-cache-storage-plug]] | The `ExpireCacheStoragePlug` class and its the `expire_cache` package backend | `lib/expire_cache_storage_plug.dart` | storage, provider, plug, expire-cache-storage-plug |

## Narrative — Concepts

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/concepts/storage-contract]] | The `PluggableStorageProvider` key/value contract | `lib/expire_cache_storage_plug.dart` | contract, key-value, provider, session |

## Narrative — Guides

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/guides/using-the-storage-plug]] | Installing the plug and reading/writing values | `lib/expire_cache_storage_plug.dart` | guide, install, get, put |

## Structure Layer

| File | Content |
|---|---|
| [structure/README.md](structure/README.md) | Generation banner + regeneration command |
| [structure/routes.md](structure/routes.md) | Routes (n/a) |
| [structure/models.md](structure/models.md) | Models |
| [structure/components.md](structure/components.md) | UI components (n/a) |
| [structure/blast.md](structure/blast.md) | High-impact files |
| [structure/hotspots.md](structure/hotspots.md) | Entry points, config |
| [structure/libraries.md](structure/libraries.md) | Dependency inventory |
| [structure/manifest.json](structure/manifest.json) | Machine-readable symbol index |

## Page Relationships

- `expire-cache-storage-plug` ↔ `storage-contract` (class implements the contract)
- `expire-cache-storage-plug` ↔ `using-the-storage-plug` (guide uses the class)
- `storage-contract` ↔ `using-the-storage-plug` (guide applies the contract)

## Stats

- Narrative pages: 3
- Structure: codesight-generated
- Last updated: 2026-06-10
