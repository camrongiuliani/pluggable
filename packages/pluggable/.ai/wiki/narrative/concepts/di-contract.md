---
title: DI Contract
category: concept
sources: [lib/src/di/pluggable_di.dart]
last_updated: 2026-06-10
related: [narrative/architecture/plug-system, narrative/modules/pluggable-module]
covers_packages: [pluggable]
---

# DI Contract

`PluggableDI` is the abstract dependency-injection contract. It is a `Plug`, so a concrete DI backend is installed as a plug and resolved by the runtime; modules register and resolve dependencies through this abstract interface.

## Operations

`PluggableDI` declares registration, resolution, scoping, and reassignment. Representative members:

- `addSingleton` / `addLazySingleton` — register eager or lazy singletons, with optional `name` and `dispose` callback.
- `get<T>` / `maybeGet<T>` — resolve (throwing) or resolve-or-null.
- `pushScope` / `popScope` / `replaceScope` / `containsScope` — named scope management.
- `allowReassignment` / `unregister<T>`.

Two function typedefs support registration: `DependencyBuilder<T>` (constructs a `T`) and `DependencyDisposeFunc<T>` (cleans one up). For the full member list, see [structure/manifest.json](../../structure/manifest.json).

## Scopes and modules

Named scopes are the mechanism behind module isolation: a module pushes a uniquely-named scope when it binds and pops it when it unbinds (see [[narrative/modules/pluggable-module]]), so its registrations appear and disappear as a unit. Resolution checks the top scope first and falls through to lower scopes.

## See Also

- [[narrative/architecture/plug-system]] — DI is one contract among several.
- [[narrative/modules/pluggable-module]] — uses scopes for isolation.
