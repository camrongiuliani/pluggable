# pluggable — Overview

`pluggable` is the core of the Pluggable plug-n-play framework. It defines the plug system every binding and plug builds on: the `Plug` base contract, the `PluggableImpl` runtime with its global `Pluggable` accessor and `initPluggable` bootstrap, the `PluggableModule` unit of composition, and the abstract contracts for dependency injection, storage, logging, mapping, analytics, HTTP, and environment.

The framework's central idea is that capabilities are **swappable plugs behind abstract contracts**. The core owns the contracts and the orchestration; concrete behavior is supplied by plug packages, and runtime adaptation (Flutter, server) is supplied by binding packages. Application code talks to the abstract contracts through the `Pluggable` runtime, so any backend can be substituted without changing app or module code.

This wiki is self-contained: it explains the plug system, the runtime, modules, and every abstract contract the core defines, without requiring any other package's wiki.

## Narrative layer

- [[narrative/architecture/plug-system]] — what a plug is and how contracts/implementations relate.
- [[narrative/modules/pluggable-runtime]] — `PluggableImpl`, the `Pluggable` accessor, `initPluggable`, the event bus.
- [[narrative/modules/pluggable-module]] — modules: scoped binding, dependency and mapper registration.
- [[narrative/concepts/di-contract]] — `PluggableDI`.
- [[narrative/concepts/storage-contract]] — `PluggableStorage` / `PluggableStorageProvider`.
- [[narrative/concepts/logger-and-analytics]] — `PluggableLogger` / `PluggableAnalytics`.
- [[narrative/concepts/mapper-and-http]] — `PluggableMapper` and the HTTP request/response models.

## Structure layer

- [structure/README.md](structure/README.md) — generation banner.
- [structure/manifest.json](structure/manifest.json) — machine-readable symbol index (the authoritative list of every class/method).
- [structure/models.md](structure/models.md) / [structure/libraries.md](structure/libraries.md).
- [structure/blast.md](structure/blast.md), [structure/hotspots.md](structure/hotspots.md).

## Which layer answers which question

| Question | Layer |
|---|---|
| "Where is `Plug`/`PluggableImpl`/`PluggableDI` defined?" | `structure/manifest.json` |
| "What HTTP models exist?" | `structure/models.md` / `structure/manifest.json` |
| "What does the core depend on?" | `structure/libraries.md` |
| "What is a plug and why?" | `narrative/architecture/plug-system` |
| "How does init work?" | `narrative/modules/pluggable-runtime` |
| "How does a module isolate its deps?" | `narrative/modules/pluggable-module` |
