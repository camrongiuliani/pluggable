---
title: Log Batching
category: concept
sources: [lib/src/util/log_batcher.dart]
last_updated: 2026-06-10
related: [narrative/modules/datadog-logger-plug, narrative/concepts/sanitization]
covers_packages: [datadog_logger_plug]
---

# Log Batching

`LogBatcher` buffers `DDLogRequest`s and flushes them to the Datadog logs intake in batches, so high log volume does not generate one HTTP request per line.

## Buffering and flushing

- Logs are appended to an in-memory queue.
- A batch is flushed when it reaches `batchSize` (default 100) or when the `batchInterval` timer fires (default 5 seconds).
- Connect/receive timeouts are configurable.

## Off-main-thread delivery

On non-web platforms the batcher spins up an `Isolate` and sends queued logs to it over a `SendPort`, so network I/O for log delivery does not block the main isolate. On web, where isolates are unavailable, it falls back to a periodic timer on the main thread.

Payloads are obfuscated before they enter the queue — see [[narrative/concepts/sanitization]].

For exact symbols, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/modules/datadog-logger-plug]] — enqueues logs onto the batcher.
- [[narrative/concepts/sanitization]] — applied before batching.
