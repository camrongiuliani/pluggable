---
title: PluggableGetIt
category: module
sources: [lib/pluggable_di_getit.dart]
last_updated: 2026-06-10
related: [narrative/concepts/di-scopes, narrative/guides/using-the-di-plug]
covers_packages: [pluggable_di_getit]
---

# PluggableGetIt

`PluggableGetIt` is the single public class of this package. It is a dependency-injection plug that satisfies the framework's `PluggableDI` contract by delegating to the [`get_it`](https://pub.dev/packages/get_it) service locator singleton (`GetIt.instance`).

## Role

The Pluggable framework defines DI as an abstract contract (`PluggableDI`, a `Plug`). Application and module code resolves dependencies through that abstract interface and never references `get_it` directly. `PluggableGetIt` is the default binding the framework installs, so swapping DI backends is a one-line change at app init.

## Contract it satisfies

`PluggableDI` declares registration, resolution, scope, and reassignment operations. `PluggableGetIt` maps each onto `get_it`:

| Contract method | `get_it` call |
|---|---|
| `addSingleton` | `registerSingleton` (eagerly constructs via `constructor.call()`) |
| `addLazySingleton` | `registerLazySingleton` (constructs on first resolve) |
| `get<T>` | resolves, throws `StateError` if unregistered |
| `maybeGet<T>` | returns `null` if not registered |
| `unregister<T>` | `unregister`, no-op if not registered |
| `pushScope` / `popScope` / `replaceScope` / `containsScope` | named scopes (see [[narrative/concepts/di-scopes]]) |
| `allowReassignment` | sets `GetIt.allowReassignment = true` |

`get` is implemented in terms of `maybeGet` and throws a `StateError` with the type name when a dependency is missing — the package's main failure mode for misconfiguration.

For the full method/parameter inventory, see [structure/manifest.json](../../structure/manifest.json). For the contract definition itself, see the framework core (`pluggable`).

## Lifecycle

`init` and `dispose` (inherited `Plug` methods) are no-ops returning `this` — `get_it`'s singleton needs no setup or teardown beyond scope management. Registration/disposal of individual dependencies is driven by modules through scopes.

## See Also

- [[narrative/concepts/di-scopes]] — the scope mechanism modules depend on.
- [[narrative/guides/using-the-di-plug]] — registering and resolving dependencies.
