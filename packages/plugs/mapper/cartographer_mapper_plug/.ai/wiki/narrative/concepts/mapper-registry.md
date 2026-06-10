---
title: Mapper Registry
category: concept
sources: [lib/cartographer_mapper_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/cartographer-mapper-plug, narrative/guides/registering-mappers]
covers_packages: [cartographer_mapper_plug]
---

# Mapper Registry

The framework defines object mapping as an abstract `PluggableMapper` contract plus two mapper base classes, `Mapper<FROM, TO>` and `AsyncMapper<FROM, TO>`. `CartographerMapperPlug` is a concrete registry that implements this contract.

## The contract

- A `Mapper<FROM, TO>` converts a `FROM` object to a `TO` via `map(source)`. An `AsyncMapper<FROM, TO>` converts via `mapAsync(source)` and throws if `map` is called synchronously.
- `PluggableMapper` exposes `buildAtlas` (register a batch of mappers), `map` / `maybeMap` / `mapAsync` / `maybeMapAsync` (convert), and `isMapped` (existence check). Each conversion call is parameterized by source and target type and accepts an optional `named` discriminator.

## Lookup rules

A conversion request resolves a mapper by:

1. Filtering the registry to sync or async mappers (async lookups only consider `AsyncMapper`).
2. Selecting the first mapper whose `isMapperFor<FROM, TO>(named)` matches the requested type pair and name.

A missing match raises `MapperNotRegistered<FROM, TO>` for the throwing variants, or yields `null`/`null`-future for the `maybe` variants. The optional name lets multiple mappers coexist for the same type pair.

## See Also

- [[narrative/modules/cartographer-mapper-plug]] — the implementing class.
- [[narrative/guides/registering-mappers]] — registering and invoking mappers.
