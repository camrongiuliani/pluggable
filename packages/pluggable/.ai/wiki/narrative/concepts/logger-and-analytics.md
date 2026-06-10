---
title: Logger and Analytics Contracts
category: concept
sources: [lib/src/logger/pluggable_logger.dart, lib/src/analytics/pluggable_analytics.dart, lib/src/env/pluggable_env.dart]
last_updated: 2026-06-10
related: [narrative/architecture/plug-system, narrative/modules/pluggable-runtime]
covers_packages: [pluggable]
---

# Logger and Analytics Contracts

The core defines abstract logging and analytics contracts (plus environment config) and ships default no-op-ish implementations so the framework works before any custom plug is installed.

## `PluggableLogger`

`PluggableLogger` is a `Plug` declaring severity methods, each taking a message and optional `tag`: `v` (verbose), `d` (debug), `i` (info), `header`, and `e` (error). The core ships `ConsoleLoggerPlug`, the default installed by `initPluggable` and the fallback `Pluggable.logger` uses during init. Logger plugs (e.g. a Datadog logger) replace it.

## `PluggableAnalytics`

`PluggableAnalytics` is a `Plug` declaring `log`, `addExtraInfo`, and `setUserInfo`. The default `NoAnalyticsPlug` is a no-op, installed when no analytics plug is supplied.

## `PluggableEnv`

`PluggableEnv` is the abstract environment-config base: constructed with a name, it exposes a `validate()` hook and typed environment accessors (e.g. string/int getters with defaults). Apps subclass it to declare and validate their configuration.

For the full member lists, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/architecture/plug-system]] — logger/analytics are contracts.
- [[narrative/modules/pluggable-runtime]] — installs the defaults.
