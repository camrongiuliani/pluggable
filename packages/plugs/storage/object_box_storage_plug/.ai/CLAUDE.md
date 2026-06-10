# object_box_storage_plug — Wiki Schema

Wiki schema for the `object_box_storage_plug` package: a **storage plug** for the Pluggable plug-n-play framework. It implements the framework's `PluggableStorageProvider` contract using ObjectBox (via `stash` + `stash_objectbox`).

This wiki is **standalone** — it documents this package completely without requiring any other wiki. Cross-package references (e.g. to the framework core or sibling storage plugs) appear only as optional "see also" links.

## Domain

`object_box_storage_plug` provides persistent on-device storage backed by the ObjectBox NoSQL database. Its single public class, `ObjectBoxStoragePlug`, extends `PluggableStorageProvider`, so it can be slotted into a `PluggableStorage` as the `local` or `remote` provider. Storage is persistent across app restarts.

## Relationship to other wikis

- **Implements a contract owned by the framework core** (`pluggable`): `PluggableStorageProvider`, `PluggableStorage`, the `DecodeFunc`/`Fetch` typedefs, and `InFlightMixin` are defined there. This wiki documents the implementation; the contract is covered by the `pluggable` wiki (see "see also" links).
- Sibling storage plugs implement the same contract over different backends; they are alternatives, not dependencies.
- No wiki depends on this one. It is a leaf.

## Architecture (the four wiki elements)

- `wiki/narrative/` — module intent, the storage contract, and a usage guide.
- `wiki/structure/` — codesight-generated inventory. Never hand-edited.
- `wiki/index.md` — catalog across both layers.
- `wiki/overview.md` — cold-start orientation.
- `wiki/log.md` — activity log.

## Directory layout

```
.ai/wiki/
├── raw/
├── narrative/
│   ├── modules/        # object-box-storage-plug.md
│   ├── concepts/       # storage-contract.md
│   └── guides/         # using-the-storage-plug.md
├── structure/
├── index.md
├── overview.md
└── log.md
```

## Codebase context

- Backend: ObjectBox (via `stash` + `stash_objectbox`).
- Dependencies: `stash`, `stash_objectbox`, `objectbox_flutter_libs`, `uuid`, `synchronized`, Flutter SDK, `pluggable`.

## Page conventions

- Frontmatter on every narrative page; `[[narrative/...]]` for in-wiki links, markdown links into `structure/`.
- Narrative = intent and design; exhaustive method/symbol inventory lives in `structure/`.

## Current-state discipline

Narrative pages describe the package as it is now. Change history belongs in `log.md` only.

## Session start protocol

1. Read this schema.
2. Read `wiki/overview.md`.
3. "Where is X / what exists" → `structure/manifest.json`; "why / how" → `narrative/`.
