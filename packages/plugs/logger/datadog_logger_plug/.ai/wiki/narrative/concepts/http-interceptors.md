---
title: HTTP Interceptors
category: concept
sources: [lib/src/datadog_plug.dart, lib/src/mappers/dio/]
last_updated: 2026-06-10
related: [narrative/modules/datadog-logger-plug, narrative/concepts/sanitization]
covers_packages: [datadog_logger_plug]
---

# HTTP Interceptors

Beyond plain log lines, `DataDogAnalyticsPlug` captures HTTP request/response telemetry from three client/server stacks and ships it to Datadog as structured `DDApiLogRequest`s.

## Supported stacks

- **Dio** — the plug's `onRequest` / `onResponse` / `onError` interceptor hooks observe Dio traffic. Dio types are converted to neutral telemetry via the `lib/src/mappers/dio/` mappers (request, response, HTTP method, form data, form file).
- **`http` package** — `LoggingClient` wraps an `http.BaseClient` and logs each `send`.
- **Shelf / Dart Frog** — server-side mixins observe `shelf` and `dart_frog` requests and responses.

## Captured detail

Telemetry is assembled from the package's detail models — request, response, URL, and HTTP content details — and packaged into the api-log request model. Bodies and headers pass through the `Sanitizer` first — see [[narrative/concepts/sanitization]].

For the full model/symbol inventory, see [structure/models.md](../../structure/models.md) and [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/modules/datadog-logger-plug]] — hosts the interceptor mixins.
- [[narrative/concepts/sanitization]] — applied to captured payloads.
