# datadog_logger_plug — Wiki Index

Content catalog. See [overview.md](overview.md) for orientation.

## Overview

[overview.md](overview.md) — two-layer orientation homepage.

## Narrative — Modules

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/modules/datadog-logger-plug]] | The `DataDogAnalyticsPlug` logger class | `lib/src/datadog_plug.dart` | logger, datadog, plug, telemetry |

## Narrative — Concepts

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/concepts/logger-contract]] | The `PluggableLogger` severity contract | `lib/src/datadog_plug.dart` | contract, logger, severity, console |
| [[narrative/concepts/log-batching]] | Buffering and isolate/timer flushing (`LogBatcher`) | `lib/src/util/log_batcher.dart` | batch, isolate, flush, intake |
| [[narrative/concepts/http-interceptors]] | Dio/Shelf/Dart Frog telemetry capture | `lib/src/datadog_plug.dart`, `lib/src/mappers/dio/` | dio, shelf, dart_frog, telemetry |
| [[narrative/concepts/sanitization]] | Obfuscating sensitive fields (`Sanitizer`) | `lib/src/util/sanitizer.dart` | obfuscate, mask, security, json |

## Narrative — Guides

| Page | Summary | Code Paths | Tags |
|---|---|---|---|
| [[narrative/guides/configuring-the-logger]] | Constructing and installing the plug | `lib/src/datadog_plug.dart` | guide, config, install, log-level |

## Structure Layer

| File | Content |
|---|---|
| [structure/README.md](structure/README.md) | Generation banner + regeneration command |
| [structure/routes.md](structure/routes.md) | Routes (n/a) |
| [structure/models.md](structure/models.md) | Models (log/request/response detail models) |
| [structure/components.md](structure/components.md) | UI components (n/a) |
| [structure/blast.md](structure/blast.md) | High-impact files |
| [structure/hotspots.md](structure/hotspots.md) | Entry points, config |
| [structure/libraries.md](structure/libraries.md) | Dependency inventory |
| [structure/manifest.json](structure/manifest.json) | Machine-readable symbol index |

## Page Relationships

- `datadog-logger-plug` ↔ `logger-contract` (class implements the contract)
- `datadog-logger-plug` ↔ `log-batching` (enqueues onto LogBatcher)
- `datadog-logger-plug` ↔ `http-interceptors` (hosts interceptor mixins)
- `datadog-logger-plug` ↔ `sanitization` (sanitizes payloads)
- `datadog-logger-plug` ↔ `configuring-the-logger` (guide uses the class)
- `logger-contract` ↔ `log-batching`
- `log-batching` ↔ `sanitization` (sanitize before batch)
- `http-interceptors` ↔ `sanitization` (sanitize captured bodies)
- `logger-contract` ↔ `configuring-the-logger`
- `log-batching` ↔ `configuring-the-logger`

## Stats

- Narrative pages: 6
- Structure: codesight-generated
- Last updated: 2026-06-10
