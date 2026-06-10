---
title: Storage Contract
category: concept
sources: [lib/redis_storage_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/redis-storage-plug, narrative/guides/using-the-storage-plug]
covers_packages: [redis_storage_plug]
---

# Storage Contract

The framework defines storage as an abstract `PluggableStorageProvider`. Every storage plug — including `RedisStoragePlug` — implements this contract, which is why backends are interchangeable behind a `PluggableStorage`.

## The contract

`PluggableStorageProvider` declares a key/value contract over typed sessions. The concrete provider implements:

- `open<T>` / `close<T>` — open or close a per-type storage session.
- `get<T>` / `put<T>` / `putIfAbsent<T>` / `getAndPut<T>` — read and write typed values, with an optional fetch fallback and trace id on reads.
- `containsKey<T>` / `keys<T>` / `getAllForType` — inspect stored keys.
- `dump<T>` — drop a type's stored data.
- `init` / `dispose` — provider lifecycle (inherited from `Plug`).

Reads accept an optional `Fetch<T>` callback so a miss can be backfilled, and an optional `trace` string for diagnostics. The `InFlightMixin` (mixed into the base contract) de-duplicates concurrent in-flight reads for the same key.

## How `RedisStoragePlug` fulfils it

`RedisStoragePlug` maps these operations onto a Redis server (via the `redis` package). Backend-specific behavior:

- An internal `_RedisAdapter` handles the low-level Redis connection, value (de)serialization, and key scanning.
- Provides distributed locking helpers (`acquireLock` / `releaseLock` / `isExtLocked`) for coordinating across processes.
- Surfaces connection/serialization failures through the package's `exceptions.dart` types.

## See Also

- [[narrative/modules/redis-storage-plug]] — the implementing class.
- [[narrative/guides/using-the-storage-plug]] — using the contract in practice.
