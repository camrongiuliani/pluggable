---
title: Choosing Plugs
category: guide
sources: [packages/pluggable/lib/pluggable.dart]
last_updated: 2026-06-10
related: [narrative/architecture/plug-catalog, narrative/architecture/layering]
---

# Choosing Plugs

When assembling a Pluggable app you select one plug per contract (storage takes two: a `local` and a `remote` provider). This guide orients the choice; each plug's own wiki has the details.

## Pick a runtime binding first

- Building a Flutter app → use `pluggable_flutter` and pass a navigator plug (`go_router_plug`).
- Building an HTTP service → use `pluggable_dart_server` and pass a server plug (`dart_frog_server_plug`).

## Storage

| Need | Plug |
|---|---|
| Throwaway / test / cache, no persistence | `in_memory_storage_plug` |
| In-memory but auto-expiring entries | `expire_cache_storage_plug` |
| Persistent on-device (mobile/desktop) | `object_box_storage_plug` |
| Persistent and encrypted at rest (secrets) | `secure_storage_plug` |
| Shared/remote across processes | `redis_storage_plug` |

A common pattern is a fast local provider plus a shared remote provider in one `PluggableStorage`.

## Logging

- Default `ConsoleLoggerPlug` (from the core) for local development.
- `datadog_logger_plug` to ship logs and HTTP telemetry to Datadog (with batching and sanitization).

## DI and mapping

The defaults — `pluggable_di_getit` (DI) and `cartographer_mapper_plug` (mapper) — are installed automatically and cover most needs; substitute only if you have a specific reason.

## How to install

Pass your chosen plugs to the binding's `initPluggable` / `runPluggableApp`. Omitted core plugs fall back to defaults (see [[narrative/architecture/plug-catalog]]); navigator and server plugs are required by their bindings.

## See Also

- [[narrative/architecture/plug-catalog]] — full contract-to-plug table.
- [[narrative/architecture/layering]] — how the layers fit together.
