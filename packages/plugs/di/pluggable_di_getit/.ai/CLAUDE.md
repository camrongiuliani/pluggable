# pluggable_di_getit — Wiki Schema

This is the wiki schema for the `pluggable_di_getit` package: a dependency-injection **plug** for the Pluggable plug-n-play framework. It backs the framework's `PluggableDI` contract with the [`get_it`](https://pub.dev/packages/get_it) service locator.

This wiki is **standalone** — it documents this package completely without requiring any other wiki. Cross-package references (e.g. to the framework core) appear only as optional "see also" links.

## Domain

`pluggable_di_getit` exposes a single public class, `PluggableGetIt`, that implements the framework's `PluggableDI` abstract interface. It is the default DI plug wired in by `initPluggable`. Responsibilities:

- Register singletons and lazy singletons, with optional names and dispose callbacks.
- Resolve dependencies by type (`get` / `maybeGet`).
- Manage named DI scopes (push / pop / replace / contains) used by Pluggable modules to isolate their dependencies.
- Toggle reassignment to allow overwriting registrations.

## Relationship to other wikis

- **Implements a contract owned by the framework core** (`pluggable` package). The `PluggableDI` abstract class and the `DependencyBuilder` / `DependencyDisposeFunc` typedefs are defined there. This wiki documents the *implementation*; the contract itself is covered by the `pluggable` wiki. See optional "see also" links on the module page.
- No wiki depends on this one. It is a leaf.

## Architecture (the four wiki elements)

- `wiki/narrative/` — hand/agent-authored prose: module intent, the DI contract this plug satisfies, and a how-to guide.
- `wiki/structure/` — codesight-generated mechanical inventory (symbols, libraries, blast). Never hand-edited.
- `wiki/index.md` — content catalog across both layers.
- `wiki/overview.md` — cold-start orientation homepage.
- `wiki/log.md` — append-only activity log.

## Directory layout

```
.ai/wiki/
├── raw/
├── narrative/
│   ├── modules/        # pluggable-getit.md
│   ├── concepts/       # di-scopes.md
│   └── guides/         # using-the-di-plug.md
├── structure/          # codesight-generated
├── index.md
├── overview.md
└── log.md
```

## Codebase context

- Single library `lib/pluggable_di_getit.dart` exporting `PluggableGetIt`.
- Depends on `get_it` (service locator) and `pluggable` (contract).

## Page conventions

- Frontmatter on every narrative page (`title`, `category`, `sources`, `last_updated`, `related`, `covers_packages`).
- `[[narrative/<category>/<page>]]` for in-wiki links; markdown links into `structure/`.
- Narrative = intent and design; exhaustive symbol/method inventory lives in `structure/`.

## Current-state discipline

Narrative pages describe the package as it is now. Evolution and change history belong in `log.md` only.

## Session start protocol

1. Read this schema.
2. Read `wiki/overview.md` for two-layer orientation.
3. For "where is X / what exists" questions, consult `structure/manifest.json` first; for "why / how" questions, read `narrative/`.
