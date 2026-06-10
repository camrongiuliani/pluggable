# cartographer_mapper_plug — Overview

`cartographer_mapper_plug` is the default mapper plug for the Pluggable plug-n-play framework. It implements the framework's `PluggableMapper` contract: a registry of typed mappers that convert objects from one type to another, synchronously or asynchronously.

A "plug" satisfies an abstract contract so it can be swapped without changing application code. `CartographerMapperPlug` is the mapper installed by default when an app calls `initPluggable`. Modules contribute their own mappers to the registry when they bind, and any code can then request a conversion by source and target type (optionally named to disambiguate multiple mappers for the same pair).

This wiki is self-contained: it explains the plug, the mapper contract it satisfies, and how to register and invoke mappers, without requiring any other package's wiki.

## Narrative layer

- [[narrative/modules/cartographer-mapper-plug]] — the `CartographerMapperPlug` class and its registry.
- [[narrative/concepts/mapper-registry]] — the `PluggableMapper` / `Mapper` / `AsyncMapper` contract and lookup rules.
- [[narrative/guides/registering-mappers]] — defining and registering mappers, invoking conversions.

## Structure layer

- [structure/README.md](structure/README.md) — generation banner.
- [structure/manifest.json](structure/manifest.json) — machine-readable symbol index.
- [structure/libraries.md](structure/libraries.md) — dependency inventory.
- [structure/blast.md](structure/blast.md), [structure/hotspots.md](structure/hotspots.md).

## Which layer answers which question

| Question | Layer |
|---|---|
| "Where is `map`/`buildAtlas` defined?" | `structure/manifest.json` |
| "What does this plug depend on?" | `structure/libraries.md` |
| "How does mapper lookup work?" | `narrative/concepts/mapper-registry` |
| "How do I register a mapper?" | `narrative/guides/registering-mappers` |
| "What class implements the mapper?" | `narrative/modules/cartographer-mapper-plug` |
