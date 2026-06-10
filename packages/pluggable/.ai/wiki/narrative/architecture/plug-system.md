---
title: Plug System
category: architecture
sources: [lib/src/plug.dart, lib/src/pluggable/pluggable.dart]
last_updated: 2026-06-10
related: [narrative/modules/pluggable-runtime, narrative/modules/pluggable-module, narrative/concepts/di-contract]
covers_packages: [pluggable]
---

# Plug System

The plug system is the core idea of the framework: every capability is a swappable component behind an abstract contract, so implementations can be substituted without changing the code that uses them.

## `Plug<T>`

`Plug<T extends Plug<T>>` is the base of everything pluggable. It defines `init()` and `dispose()` (both default to returning `this`) and `sameType<X>()`, which uses the generic type parameter to compare plug identity. The self-referential type parameter lets the runtime index plugs by their contract type.

## Contracts and implementations

Each capability is an abstract subclass of `Plug` — `PluggableDI`, `PluggableStorageProvider`, `PluggableLogger`, `PluggableMapper`, `PluggableAnalytics`. The core defines the contract; a plug package provides a concrete subclass. Because resolution is by contract type, exactly one implementation of each contract is active at a time and callers depend only on the abstract type.

## Composition

`PluggableModule` (see [[narrative/modules/pluggable-module]]) is itself a `Plug`. It bundles related functionality and registers its dependencies and mappers when bound. The `PluggableImpl` runtime (see [[narrative/modules/pluggable-runtime]]) holds the active plug set and resolves them by type.

For the full type inventory, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/modules/pluggable-runtime]] — holds and resolves plugs.
- [[narrative/modules/pluggable-module]] — composition unit.
- [[narrative/concepts/di-contract]] — an example contract.
