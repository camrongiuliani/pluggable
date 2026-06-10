# datadog_logger_plug — Wiki Schema

Wiki schema for the `datadog_logger_plug` package: a **logger plug** for the Pluggable plug-n-play framework. It implements the framework's `PluggableLogger` contract and ships logs (and HTTP request/response telemetry) to Datadog.

This wiki is **standalone** — it documents this package completely without requiring any other wiki. Cross-package references appear only as optional "see also" links.

## Domain

`datadog_logger_plug` exposes `DataDogAnalyticsPlug`, a `PluggableLogger` that mirrors logs to the console and batches them to the Datadog logs intake API. It includes HTTP client interceptors (Dio, Shelf, Dart Frog) that capture request/response telemetry, a `Sanitizer` that obfuscates sensitive fields, a `LogBatcher` that buffers and flushes logs (on an isolate off-web, a timer on web), and a set of log/request/response models.

## Relationship to other wikis

- **Implements a contract owned by the framework core** (`pluggable`): `PluggableLogger`, `ConsoleLoggerPlug`, and `Plug` are defined there. This wiki documents the implementation; the contract is covered by the `pluggable` wiki (see "see also" links).
- No wiki depends on this one. It is a leaf.

## Architecture (the four wiki elements)

- `wiki/narrative/` — module intent, the logger contract, batching, HTTP interceptors, sanitization, and a usage guide.
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

- `lib/src/datadog_plug.dart` — `DataDogAnalyticsPlug` + Dio/Shelf/Dart Frog interceptor mixins + `LoggingClient`.
- `lib/src/util/` — `LogBatcher`, `Sanitizer`, `ContentDetails`.
- `lib/src/models/` — `DDLogRequest`/`DDApiLogRequest`, request/response/url/http detail models, and enums (`LogLevel`, `LogType`, `StatusCategory`).
- `lib/src/mappers/dio/` — Dio request/response/method/form mappers.
- Depends on `dio`, `http`, `shelf`, `dart_frog`, `collection`, `synchronized`, `universal_io`, `uuid`, `pluggable`.

## Page conventions

- Frontmatter on every narrative page; `[[narrative/...]]` for in-wiki links, markdown links into `structure/`.
- Narrative = intent and design; exhaustive symbol/model inventory lives in `structure/`.

## Current-state discipline

Narrative pages describe the package as it is now. Change history belongs in `log.md` only.

## Session start protocol

1. Read this schema.
2. Read `wiki/overview.md`.
3. "Where is X / what exists" → `structure/manifest.json`; "why / how" → `narrative/`.
