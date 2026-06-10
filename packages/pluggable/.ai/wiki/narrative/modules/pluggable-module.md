---
title: Pluggable Module
category: module
sources: [lib/src/module/pluggable_module.dart]
last_updated: 2026-06-10
related: [narrative/architecture/plug-system, narrative/modules/pluggable-runtime, narrative/concepts/di-contract, narrative/concepts/mapper-and-http]
covers_packages: [pluggable]
---

# Pluggable Module

`PluggableModule` is the unit of composition: a self-contained `Plug` that registers its own dependencies and mappers when bound and tears them down when unbound. Apps are assembled from modules.

## Identity and per-module plug overrides

Each module gets a UUID `key` and a derived `_diKey` (`'<runtimeType>_<uuid>'`) used as its DI scope name. A module may be constructed with its own `storagePlugin`, `diPlugin`, `analyticsPlugin`, `loggerPlugin`, or `mapperPlugin`; the `storage`/`di`/`analytics`/`logger`/`mapper` getters return the override if present, otherwise the system default from `Pluggable`.

## Registration hooks

Subclasses override:

- `addDependencies(PluggableDI i)` — register the module's dependencies.
- `registerMappers(PluggableMapper cartograph)` — return the module's mappers.

## Binding lifecycle

- `bind([log])` pushes the module's DI scope, calls `addDependencies`, builds the module's mappers into the active mapper via `buildAtlas`, and sets `bound = true`. It is idempotent — a bound module returns early.
- `unbind()` pops the DI scope (after a short delay) and clears `bound`, releasing the module's registrations as a unit.
- `plugin(pluggable)` registers the module with the runtime.

Scoped binding is why one module's dependencies cannot leak into or clobber another's — see [[narrative/concepts/di-contract]].

Two modules are equal when their `runtimeType` matches (`hashCode` is fixed at 0), so the runtime treats one module type as a single plug.

For exact signatures, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/modules/pluggable-runtime]] — initializes and holds modules.
- [[narrative/concepts/di-contract]] — scope isolation.
- [[narrative/concepts/mapper-and-http]] — mapper registration.
