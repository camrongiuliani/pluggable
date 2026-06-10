# dart_frog_server_plug — Wiki Schema

Wiki schema for the `dart_frog_server_plug` package: a **server plug** for the Pluggable plug-n-play framework's Dart server binding. It implements the framework's `DartServerPlug` contract on top of [`dart_frog`](https://pub.dev/packages/dart_frog).

This wiki is **standalone** — it documents this package completely without requiring any other wiki. Cross-package references appear only as optional "see also" links.

## Domain

`dart_frog_server_plug` exposes `DartFrogServerPlug` (the server implementation) plus two mapper groups, `FrogRequestMapper` and `FrogResponseMapper`, that translate between Dart Frog's `RequestContext`/`Response` and the framework's neutral `PHttpRequest`/`PHttpResponse`. It runs an HTTP server, routes requests to framework `PRequestHandler`s, and adapts request/response objects.

## Relationship to other wikis

- **Implements a contract owned by the Dart server binding** (`pluggable_dart_server`): `DartServerPlug`, `RequestHandler`, `PRequestHandler`, `PHttpRequest`, and `PHttpResponse` are defined there. This wiki documents the implementation; the contract is covered by the `pluggable_dart_server` wiki (see "see also" links).
- No wiki depends on this one. It is a leaf.

## Architecture (the four wiki elements)

- `wiki/narrative/` — module intent, the server contract, request/response mapping, and a usage guide.
- `wiki/structure/` — codesight-generated inventory. Never hand-edited.
- `wiki/index.md`, `wiki/overview.md`, `wiki/log.md`.

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

- `lib/dart_frog_server_plug.dart` — `DartFrogServerPlug` (extends `DartServerPlug`).
- `lib/mappers/request_mapper.dart` — `FrogRequestMapper` and helpers (`HttpMethodMapper`, `FormDataMapper`, `FormFileMapper`).
- `lib/mappers/response_mapper.dart` — `FrogResponseMapper`.
- Depends on `dart_frog`, `dart_frog_gen`, `uuid`, `pluggable_dart_server`.

## Page conventions

- Frontmatter on every narrative page; `[[narrative/...]]` for in-wiki links, markdown links into `structure/`.
- Narrative = intent and design; exhaustive symbol inventory lives in `structure/`.

## Current-state discipline

Narrative pages describe the package as it is now. Change history belongs in `log.md` only.

## Session start protocol

1. Read this schema.
2. Read `wiki/overview.md`.
3. "Where is X / what exists" → `structure/manifest.json`; "why / how" → `narrative/`.
