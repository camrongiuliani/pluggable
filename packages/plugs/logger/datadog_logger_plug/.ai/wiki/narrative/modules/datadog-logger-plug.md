---
title: DataDogAnalyticsPlug
category: module
sources: [lib/src/datadog_plug.dart]
last_updated: 2026-06-10
related: [narrative/concepts/logger-contract, narrative/concepts/log-batching, narrative/concepts/http-interceptors, narrative/concepts/sanitization, narrative/guides/configuring-the-logger]
covers_packages: [datadog_logger_plug]
---

# DataDogAnalyticsPlug

`DataDogAnalyticsPlug` is the public logger class of this package. It extends `PluggableLogger` and mixes in Dio, Shelf, and Dart Frog interceptor behavior, mirroring logs to a console logger while batching them to Datadog.

## Role

The framework models logging as a swappable `PluggableLogger` contract. `DataDogAnalyticsPlug` is one backend; an app installs it as `loggingPlugin` and all code logs through the abstract `Pluggable.logger`, so the logging destination is interchangeable.

## Construction

Constructed with Datadog connection settings — `apiKey`, `loggingUrl`, `source`, `service`, `hostname` — plus tuning options: `batchInterval`, `batchSize`, connect/receive timeouts, and separate `consoleLogLevel` / `remoteLogLevel` thresholds. It builds an internal `ConsoleLoggerPlug` for local mirroring and a `LogBatcher` for remote delivery.

## Behavior

- Implements the contract's severity methods (`v`, `d`, `i`, `header`, `e`); each respects the console vs remote log-level thresholds.
- Builds a `DDLogRequest` (`baseRequest`) carrying source/service/hostname/trace metadata, then enqueues it on the `LogBatcher` (see [[narrative/concepts/log-batching]]).
- Captures HTTP telemetry through its interceptor mixins (`onRequest`/`onResponse`/`onError` for Dio; Shelf and Dart Frog adapters) and via the `LoggingClient` `http.BaseClient` — see [[narrative/concepts/http-interceptors]].
- Obfuscates sensitive payload fields via the `Sanitizer` before transmission — see [[narrative/concepts/sanitization]].

For the exact method and model inventory, see [structure/manifest.json](../../structure/manifest.json). The contract types are defined by the framework core (`pluggable`).

## See Also

- [[narrative/concepts/logger-contract]] — the contract this class implements.
- [[narrative/concepts/log-batching]], [[narrative/concepts/http-interceptors]], [[narrative/concepts/sanitization]] — supporting mechanisms.
- [[narrative/guides/configuring-the-logger]] — setup.
