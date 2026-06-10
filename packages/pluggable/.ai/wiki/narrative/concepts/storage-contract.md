---
title: Storage Contract
category: concept
sources: [lib/src/storage/pluggable_storage.dart, lib/src/storage/pluggable_storage_provider.dart, lib/src/storage/in_flight_mixin.dart]
last_updated: 2026-06-10
related: [narrative/architecture/plug-system, narrative/modules/pluggable-runtime]
covers_packages: [pluggable]
---

# Storage Contract

Storage in the core is two layers: `PluggableStorage` (a `Plug` that holds a `local` and a `remote` provider plus type decoders) and `PluggableStorageProvider` (the abstract backend a storage plug implements).

## `PluggableStorage`

`PluggableStorage` is constructed with a `local` and a `remote` `PluggableStorageProvider`. It `init`s/`dispose`s both, and maintains a registry of `DecodeFunc` decoders keyed by type:

- `addDecoder<T>` / `hasDecoder<T>` / `getDecoder<T>` — manage decoders.
- `decode<T>(input)` — convert raw data to `T` using the registered decoder (asserts one exists).

## `PluggableStorageProvider`

The provider is the abstract key/value backend, mixing in `InFlightMixin`. Representative operations:

- `open<T>` / `close<T>` — per-type storage sessions (`open` takes an `expiry` and a `fromEncodable` decoder).
- `get<T>` / `put<T>` / `putIfAbsent<T>` / `getAndPut<T>` — typed reads/writes; reads accept an optional `Fetch<T>` backfill and a `trace` id.
- `keys<T>` / `containsKey<T>` / `getAllForType` — inspect stored keys.
- `dump<T>` — drop a type's data. `isPrimitiveType<T>` classifies primitive value types.

`InFlightMixin` de-duplicates concurrent in-flight reads for the same key so a burst of identical reads issues one underlying fetch. For the full member list, see [structure/manifest.json](../../structure/manifest.json).

## Default backend

When no storage plug is supplied, `initPluggable` wires `InMemoryStoragePlug` as both `local` and `remote`. Any conforming provider can be substituted.

## See Also

- [[narrative/architecture/plug-system]] — storage is one contract among several.
- [[narrative/modules/pluggable-runtime]] — installs the default storage.
