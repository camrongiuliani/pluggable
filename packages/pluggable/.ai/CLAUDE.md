# pluggable — Wiki Schema

Wiki schema for the `pluggable` package: the **core** of the Pluggable plug-n-play framework. It defines the framework's plug contracts and orchestration — the `Plug` base, the `PluggableImpl` runtime, the `PluggableModule` unit of composition, and the abstract contracts for DI, storage, logging, mapping, analytics, HTTP, and environment.

This wiki is **standalone** — it documents the core completely without requiring any other wiki. Cross-package references (bindings, plugs) appear only as optional "see also" links.

## Domain

`pluggable` is the foundation every binding and plug builds on. It is stack-agnostic: no Flutter, no server runtime. It provides:

- The `Plug<T>` base contract (init/dispose/sameType).
- `PluggableImpl` + the global `Pluggable` accessor and `initPluggable` bootstrap.
- `PluggableModule` — self-contained, scope-isolated units that register dependencies and mappers.
- Abstract plug contracts: `PluggableDI`, `PluggableStorage` / `PluggableStorageProvider`, `PluggableLogger` (+ `ConsoleLoggerPlug`), `PluggableMapper` (+ `Mapper`/`AsyncMapper`), `PluggableAnalytics` (+ `NoAnalyticsPlug`), `PluggableEnv`, and HTTP request/response models.
- An event bus and a `UseCaseManager` (from `use_case`).

## Relationship to other wikis

- **This is the root of the layering.** Bindings (`pluggable_flutter`, `pluggable_dart_server`) adapt this core to runtimes; plugs implement its contracts. Those packages have their own standalone wikis and reference this one only as "see also."
- The repo-root umbrella wiki links DOWN to this and every other package wiki. This wiki does not depend on the umbrella.

## Architecture (the four wiki elements)

- `wiki/narrative/` — the plug system, runtime, modules, and each abstract contract.
- `wiki/structure/` — codesight-generated inventory. Never hand-edited.
- `wiki/index.md`, `wiki/overview.md`, `wiki/log.md`.

## Directory layout

```
.ai/wiki/
├── narrative/{architecture,concepts,modules,guides}/
├── structure/
├── index.md
├── overview.md
└── log.md
```

## Codebase context

- `lib/src/plug.dart` — `Plug<T>` base.
- `lib/src/pluggable/pluggable.dart` — `PluggableImpl`, `Pluggable`, `initPluggable`, `DartNotifier`.
- `lib/src/module/pluggable_module.dart` — `PluggableModule`.
- `lib/src/di/`, `lib/src/storage/`, `lib/src/logger/`, `lib/src/mapper/`, `lib/src/analytics/`, `lib/src/env/`, `lib/src/http/` — the abstract contracts and HTTP models.

## Page conventions

- Frontmatter on every narrative page; `[[narrative/...]]` for in-wiki links, markdown links into `structure/`.
- Narrative = intent and design; exhaustive symbol inventory lives in `structure/`. Contract pages name ≤5 exemplar members and point at `structure/manifest.json` for the full set.

## Current-state discipline

Narrative pages describe the core as it is now. Change history belongs in `log.md` only.

## Session start protocol

1. Read this schema.
2. Read `wiki/overview.md`.
3. "Where is X / what exists" → `structure/manifest.json`; "why / how" → `narrative/`.
