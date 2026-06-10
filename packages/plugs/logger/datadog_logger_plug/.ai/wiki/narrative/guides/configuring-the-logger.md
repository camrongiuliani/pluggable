---
title: Configuring the Logger
category: guide
sources: [lib/src/datadog_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/datadog-logger-plug, narrative/concepts/logger-contract, narrative/concepts/log-batching]
covers_packages: [datadog_logger_plug]
---

# Configuring the Logger

`DataDogAnalyticsPlug` is installed as the framework's logging plug at app init.

## Installing

```dart
await initPluggable(
  loggingPlugin: DataDogAnalyticsPlug(
    apiKey: ddApiKey,
    loggingUrl: 'https://http-intake.logs.datadoghq.com/api/v2/logs',
    source: 'flutter',
    service: 'my-app',
    hostname: 'prod',
    consoleLogLevel: LogLevel.debug,   // local verbosity
    remoteLogLevel: LogLevel.info,     // what gets shipped
    batchSize: 100,
    batchInterval: const Duration(seconds: 5),
  ),
  modules: [/* ... */],
);
```

## Logging

Log through the framework's abstract logger, not this class directly:

```dart
Pluggable.logger.i('User signed in', tag: 'Auth');
Pluggable.logger.e('Request failed', tag: 'Http');
```

Messages at or above `consoleLogLevel` print locally; messages at or above `remoteLogLevel` are batched to Datadog. Sensitive fields are obfuscated before transmission — see [[narrative/concepts/sanitization]].

## HTTP telemetry

To capture HTTP request/response telemetry, attach the plug's interceptors to your Dio client (or use the provided `LoggingClient` for the `http` package). See [[narrative/concepts/http-interceptors]].

## See Also

- [[narrative/modules/datadog-logger-plug]] — class responsibilities.
- [[narrative/concepts/logger-contract]] — the severity API.
- [[narrative/concepts/log-batching]] — batching behavior.
