# cartographer_mapper_plug — Wiki Schema

Wiki schema for the `cartographer_mapper_plug` package: the default **mapper plug** for the Pluggable plug-n-play framework. It implements the framework's `PluggableMapper` contract — a type-to-type object mapping registry.

This wiki is **standalone** — it documents this package completely without requiring any other wiki. Cross-package references appear only as optional "see also" links.

## Domain

`cartographer_mapper_plug` exposes one public class, `CartographerMapperPlug`, that maintains a registry of `Mapper` / `AsyncMapper` instances and converts objects from one type to another. It is the default mapper wired in by `initPluggable`. Pluggable modules register their mappers through this plug when they bind.

## Relationship to other wikis

- **Implements a contract owned by the framework core** (`pluggable`): `PluggableMapper`, `Mapper`, `AsyncMapper`, and the `MapperNotRegistered` exception are defined there. This wiki documents the implementation; the contract is covered by the `pluggable` wiki (see "see also" links).
- No wiki depends on this one. It is a leaf.

## Architecture (the four wiki elements)

- `wiki/narrative/` — module intent, the mapper contract, and a usage guide.
- `wiki/structure/` — codesight-generated inventory. Never hand-edited.
- `wiki/index.md`, `wiki/overview.md`, `wiki/log.md` — catalog, cold-start orientation, activity log.

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

- Single library `lib/cartographer_mapper_plug.dart` exporting `CartographerMapperPlug`.
- Depends on `collection` and `pluggable`.

## Page conventions

- Frontmatter on every narrative page; `[[narrative/...]]` for in-wiki links, markdown links into `structure/`.
- Narrative = intent and design; exhaustive symbol inventory lives in `structure/`.

## Current-state discipline

Narrative pages describe the package as it is now. Change history belongs in `log.md` only.

## Session start protocol

1. Read this schema.
2. Read `wiki/overview.md`.
3. "Where is X / what exists" → `structure/manifest.json`; "why / how" → `narrative/`.
