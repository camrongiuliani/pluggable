# Pluggable

A plug-n-play application framework for Dart and Flutter, organized as a Melos monorepo under `packages/**` with a core, two runtime bindings, and a set of plugs.

<!-- BEGIN ai-wiki -->
<!-- Managed by wiki-bootstrap / wiki-sync. Do not edit by hand — regenerate by re-running those agents. Content outside this fence is user-owned and takes precedence. -->

## Session Start (Critical — this fence is part of session start)

1. Read the wiki schema file(s) linked in the table below. Each `.ai/CLAUDE.md` houses its wiki's known-wikis table, task-type routing, prefix notation, architecture, operations, and conventions. The root umbrella schema is the entry point; for package-specific work, also read that package's schema. Every wiki listed is standalone.
2. Run `/load-wiki-context` with your task description to load specific pages before editing code.
3. **Wiki-first** — consult the wiki before reading source code.

| Wiki | Schema |
|---|---|
| Root umbrella (architecture + downward links) | [`.ai/CLAUDE.md`](.ai/CLAUDE.md) |
| pluggable (core) | [`packages/pluggable/.ai/CLAUDE.md`](packages/pluggable/.ai/CLAUDE.md) |
| pluggable_flutter (binding) | [`packages/pluggable_flutter/.ai/CLAUDE.md`](packages/pluggable_flutter/.ai/CLAUDE.md) |
| pluggable_dart_server (binding) | [`packages/pluggable_dart_server/.ai/CLAUDE.md`](packages/pluggable_dart_server/.ai/CLAUDE.md) |
| pluggable_di_getit (DI plug) | [`packages/plugs/di/pluggable_di_getit/.ai/CLAUDE.md`](packages/plugs/di/pluggable_di_getit/.ai/CLAUDE.md) |
| datadog_logger_plug (logger plug) | [`packages/plugs/logger/datadog_logger_plug/.ai/CLAUDE.md`](packages/plugs/logger/datadog_logger_plug/.ai/CLAUDE.md) |
| cartographer_mapper_plug (mapper plug) | [`packages/plugs/mapper/cartographer_mapper_plug/.ai/CLAUDE.md`](packages/plugs/mapper/cartographer_mapper_plug/.ai/CLAUDE.md) |
| go_router_plug (navigator plug) | [`packages/plugs/navigator/go_router_plug/.ai/CLAUDE.md`](packages/plugs/navigator/go_router_plug/.ai/CLAUDE.md) |
| dart_frog_server_plug (server plug) | [`packages/plugs/server/dart_frog_server_plug/.ai/CLAUDE.md`](packages/plugs/server/dart_frog_server_plug/.ai/CLAUDE.md) |
| expire_cache_storage_plug (storage plug) | [`packages/plugs/storage/expire_cache_storage_plug/.ai/CLAUDE.md`](packages/plugs/storage/expire_cache_storage_plug/.ai/CLAUDE.md) |
| in_memory_storage_plug (storage plug) | [`packages/plugs/storage/in_memory_storage_plug/.ai/CLAUDE.md`](packages/plugs/storage/in_memory_storage_plug/.ai/CLAUDE.md) |
| object_box_storage_plug (storage plug) | [`packages/plugs/storage/object_box_storage_plug/.ai/CLAUDE.md`](packages/plugs/storage/object_box_storage_plug/.ai/CLAUDE.md) |
| redis_storage_plug (storage plug) | [`packages/plugs/storage/redis_storage_plug/.ai/CLAUDE.md`](packages/plugs/storage/redis_storage_plug/.ai/CLAUDE.md) |
| secure_storage_plug (storage plug) | [`packages/plugs/storage/secure_storage_plug/.ai/CLAUDE.md`](packages/plugs/storage/secure_storage_plug/.ai/CLAUDE.md) |

<!-- END ai-wiki -->
