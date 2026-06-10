# Pluggable Monorepo — Root Wiki Schema (Umbrella)

This is the **root umbrella wiki** for the `plugg` Dart/Flutter monorepo (Melos workspace, `packages/**`). It is the top-level entry point: it explains the plug-n-play architecture and the **core → bindings → plugs** layering, and links DOWN to all 13 per-package wikis.

## Scope and direction

- The umbrella references **downward only** — it points to each package wiki and describes how the packages relate. It documents no package's internals.
- **No package wiki depends on this one.** Each per-package wiki is standalone and useful on its own. Cross-package references inside package wikis are optional "see also" links.
- For anything package-specific (a class, a method, how to use a plug), go to that package's wiki via the known-wikis table below.

## The layering

- **Core** — `pluggable`: stack-agnostic plug system, runtime, modules, and the abstract contracts (DI, storage, logging, mapping, analytics, HTTP, env).
- **Bindings** — adapt the core to a runtime: `pluggable_flutter` (Flutter app + navigation) and `pluggable_dart_server` (HTTP server + request handlers).
- **Plugs** — concrete implementations of contracts: DI, logger, mapper, navigator, server, and storage plugs.

Dependency direction: plugs and bindings depend on the core; the navigator plug depends on the Flutter binding; the server plug depends on the server binding. Nothing depends on the umbrella.

## Known wikis (downward links)

| Wiki | Layer | Schema |
|---|---|---|
| pluggable (core) | core | [`packages/pluggable/.ai/CLAUDE.md`](packages/pluggable/.ai/CLAUDE.md) |
| pluggable_flutter | binding | [`packages/pluggable_flutter/.ai/CLAUDE.md`](packages/pluggable_flutter/.ai/CLAUDE.md) |
| pluggable_dart_server | binding | [`packages/pluggable_dart_server/.ai/CLAUDE.md`](packages/pluggable_dart_server/.ai/CLAUDE.md) |
| pluggable_di_getit | plug (DI) | [`packages/plugs/di/pluggable_di_getit/.ai/CLAUDE.md`](packages/plugs/di/pluggable_di_getit/.ai/CLAUDE.md) |
| datadog_logger_plug | plug (logger) | [`packages/plugs/logger/datadog_logger_plug/.ai/CLAUDE.md`](packages/plugs/logger/datadog_logger_plug/.ai/CLAUDE.md) |
| cartographer_mapper_plug | plug (mapper) | [`packages/plugs/mapper/cartographer_mapper_plug/.ai/CLAUDE.md`](packages/plugs/mapper/cartographer_mapper_plug/.ai/CLAUDE.md) |
| go_router_plug | plug (navigator) | [`packages/plugs/navigator/go_router_plug/.ai/CLAUDE.md`](packages/plugs/navigator/go_router_plug/.ai/CLAUDE.md) |
| dart_frog_server_plug | plug (server) | [`packages/plugs/server/dart_frog_server_plug/.ai/CLAUDE.md`](packages/plugs/server/dart_frog_server_plug/.ai/CLAUDE.md) |
| expire_cache_storage_plug | plug (storage) | [`packages/plugs/storage/expire_cache_storage_plug/.ai/CLAUDE.md`](packages/plugs/storage/expire_cache_storage_plug/.ai/CLAUDE.md) |
| in_memory_storage_plug | plug (storage) | [`packages/plugs/storage/in_memory_storage_plug/.ai/CLAUDE.md`](packages/plugs/storage/in_memory_storage_plug/.ai/CLAUDE.md) |
| object_box_storage_plug | plug (storage) | [`packages/plugs/storage/object_box_storage_plug/.ai/CLAUDE.md`](packages/plugs/storage/object_box_storage_plug/.ai/CLAUDE.md) |
| redis_storage_plug | plug (storage) | [`packages/plugs/storage/redis_storage_plug/.ai/CLAUDE.md`](packages/plugs/storage/redis_storage_plug/.ai/CLAUDE.md) |
| secure_storage_plug | plug (storage) | [`packages/plugs/storage/secure_storage_plug/.ai/CLAUDE.md`](packages/plugs/storage/secure_storage_plug/.ai/CLAUDE.md) |

## Task-type routing

| Task | Where to look |
|---|---|
| Understand the framework concept (plugs, contracts, layering) | this umbrella's `wiki/narrative/architecture/` |
| Work on a contract or the runtime | `pluggable` (core) wiki |
| Work on Flutter app/navigation | `pluggable_flutter` wiki (+ `go_router_plug`) |
| Work on the HTTP server | `pluggable_dart_server` wiki (+ `dart_frog_server_plug`) |
| Work on a specific plug | that plug's wiki |
| "Which storage/logger/etc. plug do I pick?" | this umbrella's `wiki/narrative/guides/choosing-plugs` |

## Architecture (the four wiki elements)

- `wiki/narrative/` — architecture and selection guides spanning the monorepo (no per-package internals).
- `wiki/structure/` — **intentionally absent.** This is a documentation-only umbrella at the repo root; the repo root has no code to index. Each package wiki carries its own codesight structure layer.
- `wiki/index.md`, `wiki/overview.md`, `wiki/log.md`.

## Current-state discipline

Narrative pages describe the system as it is now. Change history belongs in `log.md` only.

## Session start protocol

1. Read this schema and the linked package schema(s) relevant to your task.
2. For package-specific work, open that package's wiki — each is standalone.
3. Run `/load-wiki-context` with your task to load specific pages.
