# pluggable_di_getit — Overview

`pluggable_di_getit` is the default dependency-injection plug for the Pluggable plug-n-play framework. It implements the framework's `PluggableDI` contract on top of the [`get_it`](https://pub.dev/packages/get_it) service locator, giving Pluggable applications type-based dependency resolution, singleton/lazy-singleton registration, and named scopes.

A "plug" in this framework is a swappable component that satisfies an abstract contract. `PluggableGetIt` is the concrete DI plug installed by default when an app calls `initPluggable`; an app can substitute any other `PluggableDI` implementation without touching module code, because modules only ever talk to the abstract interface.

This wiki is self-contained: it explains the plug, the contract it satisfies, and how to use it, without requiring any other package's wiki.

## Narrative layer

- [[narrative/modules/pluggable-getit]] — the `PluggableGetIt` class: what it implements, how each method maps onto `get_it`.
- [[narrative/concepts/di-scopes]] — how named DI scopes work and why Pluggable modules rely on them.
- [[narrative/guides/using-the-di-plug]] — installing the plug and registering/resolving dependencies.

## Structure layer

- [structure/README.md](structure/README.md) — generation banner and regeneration command.
- [structure/manifest.json](structure/manifest.json) — machine-readable symbol/reference index.
- [structure/libraries.md](structure/libraries.md) — dependency inventory (`get_it`, `pluggable`).
- [structure/hotspots.md](structure/hotspots.md), [structure/blast.md](structure/blast.md) — entry points and high-impact files.

## Which layer answers which question

| Question | Layer |
|---|---|
| "Where is `addSingleton` defined?" | `structure/manifest.json` |
| "What symbols does this package export?" | `structure/manifest.json` |
| "What does this plug depend on?" | `structure/libraries.md` |
| "Why does the framework use scopes for modules?" | `narrative/concepts/di-scopes` |
| "How do I register a dependency?" | `narrative/guides/using-the-di-plug` |
| "What contract does `PluggableGetIt` satisfy?" | `narrative/modules/pluggable-getit` |
