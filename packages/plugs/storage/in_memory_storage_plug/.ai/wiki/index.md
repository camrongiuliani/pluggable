# in_memory_storage_plug — Wiki Index

Content catalog for the `in_memory_storage_plug` wiki. See [overview.md](overview.md) for orientation.

## Overview

[overview.md](overview.md) — two-layer orientation homepage.

## Narrative — Modules

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/modules/in-memory-storage-plug]] | The `InMemoryStoragePlug` class and its an in-process Dart map backend | `lib/in_memory_storage_plug.dart` | storage, provider, plug, in-memory-storage-plug |

## Narrative — Concepts

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/concepts/storage-contract]] | The `PluggableStorageProvider` key/value contract | `lib/in_memory_storage_plug.dart` | contract, key-value, provider, session |

## Narrative — Guides

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/guides/using-the-storage-plug]] | Installing the plug and reading/writing values | `lib/in_memory_storage_plug.dart` | guide, install, get, put |

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

- `in-memory-storage-plug` ↔ `storage-contract` (class implements the contract)
- `in-memory-storage-plug` ↔ `using-the-storage-plug` (guide uses the class)
- `storage-contract` ↔ `using-the-storage-plug` (guide applies the contract)

## Stats

- Narrative pages: 3
- Structure: codesight-generated
- Last updated: 2026-06-10
