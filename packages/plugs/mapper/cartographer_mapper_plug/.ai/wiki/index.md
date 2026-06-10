# cartographer_mapper_plug — Wiki Index

Content catalog. See [overview.md](overview.md) for orientation.

## Overview

[overview.md](overview.md) — two-layer orientation homepage.

## Narrative — Modules

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/modules/cartographer-mapper-plug]] | The `CartographerMapperPlug` registry class | `lib/cartographer_mapper_plug.dart` | mapper, registry, plug, conversion |

## Narrative — Concepts

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/concepts/mapper-registry]] | The `PluggableMapper`/`Mapper`/`AsyncMapper` contract and lookup | `lib/cartographer_mapper_plug.dart` | contract, mapper, async, lookup |

## Narrative — Guides

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/guides/registering-mappers]] | Defining, registering, and invoking mappers | `lib/cartographer_mapper_plug.dart` | guide, buildAtlas, map, register |

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

- `cartographer-mapper-plug` ↔ `mapper-registry` (class implements the contract)
- `cartographer-mapper-plug` ↔ `registering-mappers` (guide uses the class)
- `mapper-registry` ↔ `registering-mappers` (guide applies the contract)

## Stats

- Narrative pages: 3
- Structure: codesight-generated
- Last updated: 2026-06-10
