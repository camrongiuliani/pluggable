---
title: Logger Contract
category: concept
sources: [lib/src/datadog_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/datadog-logger-plug, narrative/guides/configuring-the-logger]
covers_packages: [datadog_logger_plug]
---

# Logger Contract

The framework defines logging as an abstract `PluggableLogger` (a `Plug`). `DataDogAnalyticsPlug` implements this contract, which is why the logging backend is interchangeable behind `Pluggable.logger`.

## The contract

`PluggableLogger` declares severity methods, each taking a message and an optional `tag`:

- `v` — verbose / trace
- `d` — debug
- `i` — info
- `header` — section header
- `e` — error (with optional error object / stack trace)

The framework ships a default `ConsoleLoggerPlug` implementation. `DataDogAnalyticsPlug` composes a `ConsoleLoggerPlug` internally so it can mirror to the console while also shipping to Datadog.

## How `DataDogAnalyticsPlug` fulfils it

Each severity method writes to the console (subject to `consoleLogLevel`) and, when the message meets `remoteLogLevel`, builds a `DDLogRequest` and enqueues it on the `LogBatcher`. The split thresholds let local output be chattier than what is sent remotely.

## See Also

- [[narrative/modules/datadog-logger-plug]] — the implementing class.
- [[narrative/concepts/log-batching]] — how remote logs are delivered.
