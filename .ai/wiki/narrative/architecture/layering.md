---
title: Core → Bindings → Plugs Layering
category: architecture
sources: [packages/pluggable/lib/pluggable.dart, packages/pluggable_flutter/lib/pluggable_flutter.dart, packages/pluggable_dart_server/lib/pluggable_dart_server.dart]
last_updated: 2026-06-10
related: [narrative/architecture/plug-catalog, narrative/guides/choosing-plugs]
---

# Core → Bindings → Plugs Layering

The monorepo is organized in three layers. Each layer depends only on the layer(s) below it, and dependencies always flow toward the core.

## Core

`pluggable` is stack-agnostic — no Flutter, no server. It defines:

- the `Plug` base and the `PluggableImpl` runtime (`Pluggable` accessor, `initPluggable`),
- `PluggableModule`, the scope-isolated composition unit,
- abstract contracts: DI, storage, logging, analytics, mapping, HTTP, environment.

Concrete behavior is not in the core — only contracts and orchestration. See the [pluggable wiki](../../../../packages/pluggable/.ai/wiki/overview.md).

## Bindings

A binding adapts the core to a runtime by re-exporting it (hiding the core `initPluggable`) and adding runtime-specific entry points and contracts:

- **`pluggable_flutter`** boots a Flutter app via `runPluggableApp`, builds a `MaterialApp.router`, and owns the `PluggableNavigator` contract. See the [pluggable_flutter wiki](../../../../packages/pluggable_flutter/.ai/wiki/overview.md).
- **`pluggable_dart_server`** runs an HTTP server, defines `PRequestHandler` + validation, and owns the `DartServerPlug` contract. See the [pluggable_dart_server wiki](../../../../packages/pluggable_dart_server/.ai/wiki/overview.md).

## Plugs

A plug implements one contract with a concrete backend. Most implement core contracts directly; two implement binding-owned contracts:

- Core contracts: DI (`pluggable_di_getit`), logger (`datadog_logger_plug`), mapper (`cartographer_mapper_plug`), storage (`in_memory`, `expire_cache`, `object_box`, `redis`, `secure`).
- Binding contracts: navigator (`go_router_plug` → `pluggable_flutter`), server (`dart_frog_server_plug` → `pluggable_dart_server`).

## Dependency direction

Plugs and bindings depend on the core; the navigator and server plugs additionally depend on their binding. The umbrella depends on nothing and nothing depends on it — every package wiki is standalone.

## See Also

- [[narrative/architecture/plug-catalog]] — contract-to-plug mapping.
- [[narrative/guides/choosing-plugs]] — selecting plugs for an app.
