---
title: Sanitization
category: concept
sources: [lib/src/util/sanitizer.dart]
last_updated: 2026-06-10
related: [narrative/concepts/log-batching, narrative/concepts/http-interceptors]
covers_packages: [datadog_logger_plug]
---

# Sanitization

`Sanitizer` obfuscates sensitive values before any log or telemetry payload leaves the process, so secrets are not transmitted to Datadog.

## What it does

- `obfuscateMap(jsonMap, maskedKeys:)` returns a copy of a map with the values of any keys in `maskedKeys` obfuscated, recursing into nested maps.
- `obfuscate(message, maskedKeys:)` scans a string for embedded JSON (objects or arrays), parses it, sanitizes it recursively, and splices the sanitized JSON back into the original string. This catches secrets embedded in otherwise free-form log messages.

## Where it is applied

The `LogBatcher` runs payloads through the `Sanitizer` (matching on `String` vs `Map<String, dynamic>` body shapes) before enqueuing them, so both plain log lines and captured HTTP bodies are masked before batching and transmission.

For exact symbols, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/concepts/log-batching]] — invokes the sanitizer before queuing.
- [[narrative/concepts/http-interceptors]] — captured bodies are sanitized.
