---
title: CartographerMapperPlug
category: module
sources: [lib/cartographer_mapper_plug.dart]
last_updated: 2026-06-10
related: [narrative/concepts/mapper-registry, narrative/guides/registering-mappers]
covers_packages: [cartographer_mapper_plug]
---

# CartographerMapperPlug

`CartographerMapperPlug` is the single public class of this package. It extends `PluggableMapper` and keeps an in-memory list of `Mapper` instances, resolving conversions by matching a mapper's source/target types (and optional name).

## Role

The framework models object mapping as a swappable contract (`PluggableMapper`). `CartographerMapperPlug` is the default implementation installed by `initPluggable`. Module code never references this class directly — it talks to the abstract `PluggableMapper` (e.g. through `Pluggable.mapper`), so the mapper backend is interchangeable.

## How it works

- `buildAtlas` appends a list of `Mapper`s to the registry, logging each registered source→target pair through the framework logger.
- Lookup filters the registry by sync vs async (`AsyncMapper`) and matches on source type, target type, and optional name via each mapper's `isMapperFor`.
- `map` / `maybeMap` resolve a synchronous mapper and invoke it; `map` throws `MapperNotRegistered` on a miss, `maybeMap` returns `null`.
- `mapAsync` / `maybeMapAsync` resolve an `AsyncMapper` and await `mapAsync`; a missing or non-async mapper throws (or returns `null` for the `maybe` variant).
- `isMapped` reports whether a mapper exists for a type pair.

For the exact method signatures, see [structure/manifest.json](../../structure/manifest.json). The contract types are defined by the framework core (`pluggable`).

## See Also

- [[narrative/concepts/mapper-registry]] — the contract and lookup semantics.
- [[narrative/guides/registering-mappers]] — defining and using mappers.
