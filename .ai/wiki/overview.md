# Pluggable Monorepo — Overview (Umbrella)

This is the root umbrella wiki for the `plugg` monorepo — a Melos workspace (`packages/**`) that implements **Pluggable**, a plug-n-play application framework for Dart and Flutter. Its job is orientation: explain the architecture and link DOWN to each package's standalone wiki. It documents no package's internals.

## The plug-n-play idea

Every capability an app needs — dependency injection, storage, logging, analytics, object mapping, navigation, an HTTP server — is modeled as a **plug** behind an **abstract contract**. Application and module code talks to the contracts, never to a concrete backend, so any plug can be swapped without changing app code. An app is assembled by initializing the framework with the plugs and modules it wants.

## The layering: core → bindings → plugs

- **Core** (`pluggable`) — stack-agnostic. Defines the plug system, the runtime (`PluggableImpl` / `initPluggable`), the `PluggableModule` composition unit, and the abstract contracts.
- **Bindings** — adapt the core to a runtime. `pluggable_flutter` boots a Flutter app and owns the navigation contract; `pluggable_dart_server` runs an HTTP server and owns the request-handler model and server contract.
- **Plugs** — concrete implementations of contracts: a DI plug, a logger plug, a mapper plug, a navigator plug, a server plug, and several storage plugs.

Dependencies flow toward the core. Nothing depends on this umbrella; each package wiki stands alone.

## Where to go (downward links)

### Core

- [pluggable](../../packages/pluggable/.ai/wiki/overview.md) — plug system, runtime, modules, contracts.

### Bindings

- [pluggable_flutter](../../packages/pluggable_flutter/.ai/wiki/overview.md) — Flutter app + navigation.
- [pluggable_dart_server](../../packages/pluggable_dart_server/.ai/wiki/overview.md) — HTTP server + request handlers.

### Plugs

- [pluggable_di_getit](../../packages/plugs/di/pluggable_di_getit/.ai/wiki/overview.md) — DI (get_it).
- [datadog_logger_plug](../../packages/plugs/logger/datadog_logger_plug/.ai/wiki/overview.md) — logger (Datadog).
- [cartographer_mapper_plug](../../packages/plugs/mapper/cartographer_mapper_plug/.ai/wiki/overview.md) — object mapper.
- [go_router_plug](../../packages/plugs/navigator/go_router_plug/.ai/wiki/overview.md) — navigator (go_router).
- [dart_frog_server_plug](../../packages/plugs/server/dart_frog_server_plug/.ai/wiki/overview.md) — server (Dart Frog).
- [expire_cache_storage_plug](../../packages/plugs/storage/expire_cache_storage_plug/.ai/wiki/overview.md) — storage (expiring in-memory).
- [in_memory_storage_plug](../../packages/plugs/storage/in_memory_storage_plug/.ai/wiki/overview.md) — storage (in-memory).
- [object_box_storage_plug](../../packages/plugs/storage/object_box_storage_plug/.ai/wiki/overview.md) — storage (ObjectBox).
- [redis_storage_plug](../../packages/plugs/storage/redis_storage_plug/.ai/wiki/overview.md) — storage (Redis).
- [secure_storage_plug](../../packages/plugs/storage/secure_storage_plug/.ai/wiki/overview.md) — storage (encrypted Hive).

## Narrative layer (umbrella-level)

- [[narrative/architecture/layering]] — the core → bindings → plugs layering in depth.
- [[narrative/architecture/plug-catalog]] — what each contract is and which plugs satisfy it.
- [[narrative/guides/choosing-plugs]] — picking plugs when assembling an app.

## Structure layer

Intentionally absent. The repo root has no code to index; each package wiki carries its own codesight `structure/` layer. See any package's `overview.md` for its structure layer.

## Which layer answers which question

| Question | Where |
|---|---|
| "How do the packages relate?" | `narrative/architecture/layering` |
| "Which plug satisfies contract X?" | `narrative/architecture/plug-catalog` |
| "Which storage/logger plug should I use?" | `narrative/guides/choosing-plugs` |
| Anything package-specific | that package's wiki (links above) |
