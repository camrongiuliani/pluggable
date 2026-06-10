# pluggable_dart_server — Wiki Schema

Wiki schema for the `pluggable_dart_server` package: the **Dart server binding** of the Pluggable plug-n-play framework. It adapts the framework core to HTTP servers — defining request handlers, request validation, the server-side module base, and the `DartServerPlug` contract that concrete server plugs implement.

This wiki is **standalone** — it documents this package completely without requiring any other wiki. Cross-package references appear only as optional "see also" links.

## Domain

`pluggable_dart_server` provides `PRequestHandler` (the base for HTTP request handlers), a query/header validation system, `ServerModule` (a server-aware `PluggableModule`), `ServerEnv`, and the `DartServerPlug` abstract contract a concrete server (e.g. `dart_frog_server_plug`) implements. Handlers operate on neutral `PHttpRequest`/`PHttpResponse` types from the core.

## Relationship to other wikis

- **Builds on the framework core** (`pluggable`): re-exports the core (hiding the core `initPluggable`) and adds server bindings. Core abstractions (`Plug`, `PluggableModule`, mapper, etc.) are documented by the `pluggable` wiki.
- **Owns the contract** that server plugs implement: `dart_frog_server_plug` implements `DartServerPlug` defined here.
- These appear only as "see also" links. No wiki depends on this one.

## Architecture (the four wiki elements)

- `wiki/narrative/` — server binding, request handlers, validation, server module, server contract.
- `wiki/structure/` — codesight-generated inventory. Never hand-edited.
- `wiki/index.md`, `wiki/overview.md`, `wiki/log.md`.

## Directory layout

```
.ai/wiki/
├── narrative/{architecture,modules,concepts,guides}/
├── structure/
├── index.md
├── overview.md
└── log.md
```

## Codebase context

- `lib/src/handler/p_request_handler.dart` — `PRequestHandler` (per-method hooks, response building, error handling).
- `lib/src/validation/` — `QueryParamValidation`/`QueryParamValidator`, `HeaderValidation`/`HeaderValidator`, validation operations, exceptions.
- `lib/src/module/server_module.dart`, `server_env.dart` — `ServerModule`, `ServerEnv`.
- `lib/src/plugs/dart_server_plug.dart` — `DartServerPlug` contract + `RequestHandler` typedef.
- `lib/src/models/p_server_handler.dart`, `lib/src/pluggable_ext.dart` — server handler model + Dart `initPluggable`.
- Depends on `bloc`, `shelf`, `shelf_router`, `shelf_static`, `shelf_hotreload`, `http_methods`, `http_parser`, `mime`, `meta`, `pluggable`.

## Page conventions

- Frontmatter on every narrative page; `[[narrative/...]]` for in-wiki links, markdown links into `structure/`.
- Narrative = intent and design; exhaustive symbol inventory lives in `structure/`.

## Current-state discipline

Narrative pages describe the package as it is now. Change history belongs in `log.md` only.

## Session start protocol

1. Read this schema.
2. Read `wiki/overview.md`.
3. "Where is X / what exists" → `structure/manifest.json`; "why / how" → `narrative/`.
