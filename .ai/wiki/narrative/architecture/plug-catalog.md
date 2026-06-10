---
title: Plug Catalog
category: architecture
sources: [packages/pluggable/lib/pluggable.dart]
last_updated: 2026-06-10
related: [narrative/architecture/layering, narrative/guides/choosing-plugs]
---

# Plug Catalog

Each capability is an abstract contract with one or more concrete plugs. This catalog maps contracts to the plugs that satisfy them and to the default the framework installs when none is supplied.

## Contract → plugs

| Contract | Owner | Plugs | Default |
|---|---|---|---|
| `PluggableDI` | core | [pluggable_di_getit](../../../../packages/plugs/di/pluggable_di_getit/.ai/wiki/overview.md) | `PluggableGetIt` |
| `PluggableLogger` | core | core `ConsoleLoggerPlug`; [datadog_logger_plug](../../../../packages/plugs/logger/datadog_logger_plug/.ai/wiki/overview.md) | `ConsoleLoggerPlug` |
| `PluggableMapper` | core | [cartographer_mapper_plug](../../../../packages/plugs/mapper/cartographer_mapper_plug/.ai/wiki/overview.md) | `CartographerMapperPlug` |
| `PluggableAnalytics` | core | core `NoAnalyticsPlug` | `NoAnalyticsPlug` |
| `PluggableStorageProvider` | core | [in_memory](../../../../packages/plugs/storage/in_memory_storage_plug/.ai/wiki/overview.md), [expire_cache](../../../../packages/plugs/storage/expire_cache_storage_plug/.ai/wiki/overview.md), [object_box](../../../../packages/plugs/storage/object_box_storage_plug/.ai/wiki/overview.md), [redis](../../../../packages/plugs/storage/redis_storage_plug/.ai/wiki/overview.md), [secure](../../../../packages/plugs/storage/secure_storage_plug/.ai/wiki/overview.md) | `InMemoryStoragePlug` (local + remote) |
| `PluggableNavigator` | `pluggable_flutter` | [go_router_plug](../../../../packages/plugs/navigator/go_router_plug/.ai/wiki/overview.md) | none (required) |
| `DartServerPlug` | `pluggable_dart_server` | [dart_frog_server_plug](../../../../packages/plugs/server/dart_frog_server_plug/.ai/wiki/overview.md) | none (required) |

## Notes

- When `initPluggable` is called without a given plug, the framework installs the default in the table. Navigator and server plugs have no default — they are the runtime the app explicitly chooses.
- Storage uses two providers (`local` and `remote`) inside a single `PluggableStorage`; you may mix providers (e.g. secure local + redis remote).
- For the precise defaults and bootstrap order, see the [pluggable runtime page](../../../../packages/pluggable/.ai/wiki/narrative/modules/pluggable-runtime.md).

## See Also

- [[narrative/architecture/layering]] — how these layers depend on each other.
- [[narrative/guides/choosing-plugs]] — picking among the storage/logger options.
