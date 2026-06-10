---
title: Storage Contract
category: concept
sources: [lib/expire_cache_storage_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/expire-cache-storage-plug, narrative/guides/using-the-storage-plug]
covers_packages: [expire_cache_storage_plug]
---

# Storage Contract

The framework defines storage as an abstract `PluggableStorageProvider`. Every storage plug — including `ExpireCacheStoragePlug` — implements this contract, which is why backends are interchangeable behind a `PluggableStorage`.

## The contract

`PluggableStorageProvider` declares a key/value contract over typed sessions. The concrete provider implements:

- `open<T>` / `close<T>` — open or close a per-type storage session.
- `get<T>` / `put<T>` / `putIfAbsent<T>` / `getAndPut<T>` — read and write typed values, with an optional fetch fallback and trace id on reads.
- `containsKey<T>` / `keys<T>` / `getAllForType` — inspect stored keys.
- `dump<T>` — drop a type's stored data.
- `init` / `dispose` — provider lifecycle (inherited from `Plug`).

Reads accept an optional `Fetch<T>` callback so a miss can be backfilled, and an optional `trace` string for diagnostics. The `InFlightMixin` (mixed into the base contract) de-duplicates concurrent in-flight reads for the same key.

## How `ExpireCacheStoragePlug` fulfils it

`ExpireCacheStoragePlug` maps these operations onto the `expire_cache` package. Backend-specific behavior:

- Wraps `expire_cache` so entries are evicted automatically once their expiry elapses.
- Expiry duration is supplied through `open` when a type's storage session is opened.
- Uses `synchronized` to guard concurrent access to the cache.

## See Also

- [[narrative/modules/expire-cache-storage-plug]] — the implementing class.
- [[narrative/guides/using-the-storage-plug]] — using the contract in practice.
