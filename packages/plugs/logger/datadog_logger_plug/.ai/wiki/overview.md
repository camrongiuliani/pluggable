# datadog_logger_plug — Overview

`datadog_logger_plug` is a logger plug for the Pluggable plug-n-play framework. It implements the framework's `PluggableLogger` contract and forwards logs — and optional HTTP request/response telemetry — to Datadog, while mirroring output to the console.

A "plug" satisfies an abstract contract so it can be swapped without changing application code. `DataDogAnalyticsPlug` is installed as the `loggingPlugin` at app init; module and app code call `Pluggable.logger` (the abstract `PluggableLogger`) and never reference Datadog directly. Logs are buffered by a `LogBatcher` and flushed in batches to the Datadog intake API; sensitive fields are obfuscated by a `Sanitizer` before they leave the process. HTTP interceptor mixins capture telemetry from Dio, Shelf, and Dart Frog clients/handlers.

This wiki is self-contained: it explains the plug, the logger contract it satisfies, batching, interceptors, and sanitization, without requiring any other package's wiki.

## Narrative layer

- [[narrative/modules/datadog-logger-plug]] — the `DataDogAnalyticsPlug` class and its responsibilities.
- [[narrative/concepts/logger-contract]] — the `PluggableLogger` contract this plug satisfies.
- [[narrative/concepts/log-batching]] — how logs are buffered and flushed (`LogBatcher`).
- [[narrative/concepts/http-interceptors]] — Dio/Shelf/Dart Frog request-response telemetry.
- [[narrative/concepts/sanitization]] — obfuscating sensitive fields before transmission.
- [[narrative/guides/configuring-the-logger]] — constructing and installing the plug.

## Structure layer

- [structure/README.md](structure/README.md) — generation banner.
- [structure/manifest.json](structure/manifest.json) — machine-readable symbol index.
- [structure/models.md](structure/models.md) / [structure/libraries.md](structure/libraries.md) — model and dependency inventory.
- [structure/blast.md](structure/blast.md), [structure/hotspots.md](structure/hotspots.md).

## Which layer answers which question

| Question | Layer |
|---|---|
| "Where is `LogBatcher`/`Sanitizer` defined?" | `structure/manifest.json` |
| "What log models exist?" | `structure/models.md` / `structure/manifest.json` |
| "What does this plug depend on?" | `structure/libraries.md` |
| "How are logs batched and sent?" | `narrative/concepts/log-batching` |
| "How is sensitive data handled?" | `narrative/concepts/sanitization` |
| "How do I configure the logger?" | `narrative/guides/configuring-the-logger` |
