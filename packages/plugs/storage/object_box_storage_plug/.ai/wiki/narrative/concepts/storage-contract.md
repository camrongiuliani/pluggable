---
title: Storage Contract
category: concept
sources: [lib/object_box_storage_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/object-box-storage-plug, narrative/guides/using-the-storage-plug]
covers_packages: [object_box_storage_plug]
---

# Storage Contract

The framework defines storage as an abstract `PluggableStorageProvider`. Every storage plug — including `ObjectBoxStoragePlug` — implements this contract, which is why backends are interchangeable behind a `PluggableStorage`.

## The contract

`PluggableStorageProvider` declares a key/value contract over typed sessions. The concrete provider implements:

- `open<T>` / `close<T>` — open or close a per-type storage session.
- `get<T>` / `put<T>` / `putIfAbsent<T>` / `getAndPut<T>` — read and write typed values, with an optional fetch fallback and trace id on reads.
- `containsKey<T>` / `keys<T>` / `getAllForType` — inspect stored keys.
- `dump<T>` — drop a type's stored data.
- `init` / `dispose` — provider lifecycle (inherited from `Plug`).

Reads accept an optional `Fetch<T>` callback so a miss can be backfilled, and an optional `trace` string for diagnostics. The `InFlightMixin` (mixed into the base contract) de-duplicates concurrent in-flight reads for the same key.

## How `ObjectBoxStoragePlug` fulfils it

`ObjectBoxStoragePlug` maps these operations onto ObjectBox (via `stash` + `stash_objectbox`). Backend-specific behavior:

- Builds a `stash` store over ObjectBox; `init` provisions the underlying database directory.
- Each stored type gets its own vault opened lazily through `open`.
- Uses `synchronized` for safe concurrent vault access and `uuid` for internal keying.

## See Also

- [[narrative/modules/object-box-storage-plug]] — the implementing class.
- [[narrative/guides/using-the-storage-plug]] — using the contract in practice.
