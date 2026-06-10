---
title: Pluggable Runtime
category: module
sources: [lib/src/pluggable/pluggable.dart]
last_updated: 2026-06-10
related: [narrative/architecture/plug-system, narrative/modules/pluggable-module, narrative/concepts/logger-and-analytics]
covers_packages: [pluggable]
---

# Pluggable Runtime

`PluggableImpl` is the framework runtime: a singleton that holds the active plug set, resolves plugs by type, bootstraps the system, and carries an event bus. The global `Pluggable` getter exposes it.

## The `Pluggable` accessor

`Pluggable` returns the initialized `PluggableImpl` singleton and throws `Exception('Pluggable not initialized')` if accessed before bootstrap. Typed accessors (`di`, `logger`, `storage`, `analytics`, `mapper`) resolve the corresponding plug; `logger` falls back to a `ConsoleLoggerPlug` during initialization.

## Bootstrap — `initPluggable`

`initPluggable` builds the singleton and installs the core plugs, defaulting any not supplied:

- logger → `ConsoleLoggerPlug`
- mapper → `CartographerMapperPlug`
- DI → `PluggableGetIt`
- storage → `PluggableStorage(local: InMemoryStoragePlug(), remote: InMemoryStoragePlug())`
- analytics → `NoAnalyticsPlug`

It then initializes the system and `init()`s each supplied module. (Bindings provide their own `initPluggable` that additionally installs a navigator or server plug.)

## Plug management

- `plugin(plug, {allowReassignment, notify, init})` registers a plug, optionally disposing and replacing an existing one of the same type, then notifies listeners.
- `get<T>()` / `maybeGet<T>()` / `containsPlugin<T>()` resolve plugs by contract type.
- `modules` filters the plug set to `PluggableModule`s.

## Events and notifications

`PluggableImpl` extends `DartNotifier` (a broadcast `StreamController` exposed as `stream`) and holds an `EventBus`. `emit` fires bus events, `on<T>()` subscribes, and `notifyListeners()` drives UI/consumer rebuilds. A `UseCaseManager` (`ucm`) handles business-logic use cases.

For exact signatures, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/architecture/plug-system]] — what the runtime holds.
- [[narrative/modules/pluggable-module]] — modules initialized at bootstrap.
- [[narrative/concepts/logger-and-analytics]] — the default logger/analytics plugs.
