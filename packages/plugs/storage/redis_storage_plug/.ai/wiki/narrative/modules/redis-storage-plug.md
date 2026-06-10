---
title: RedisStoragePlug
category: module
sources: [lib/redis_storage_plug.dart]
last_updated: 2026-06-10
related: [narrative/concepts/storage-contract, narrative/guides/using-the-storage-plug]
covers_packages: [redis_storage_plug]
---

# RedisStoragePlug

`RedisStoragePlug` is the public class of this package. It extends `PluggableStorageProvider` and provides remote/shared storage backed by Redis backed by a Redis server (via the `redis` package).

## Role

The framework models storage as a swappable provider behind the `PluggableStorageProvider` contract. `RedisStoragePlug` is one concrete backend; an app selects it (as `local` and/or `remote`) when constructing a `PluggableStorage`, and module code reads/writes through the abstract contract without knowing the backend. Storage is persistent and shareable across processes.

## Backend specifics

- An internal `_RedisAdapter` handles the low-level Redis connection, value (de)serialization, and key scanning.
- Provides distributed locking helpers (`acquireLock` / `releaseLock` / `isExtLocked`) for coordinating across processes.
- Surfaces connection/serialization failures through the package's `exceptions.dart` types.

## Contract it satisfies

See [[narrative/concepts/storage-contract]] for the full method set. For the exact symbol inventory of this package, see [structure/manifest.json](../../structure/manifest.json). The contract type itself is defined by the framework core (`pluggable`).

## See Also

- [[narrative/concepts/storage-contract]] — the contract this class implements.
- [[narrative/guides/using-the-storage-plug]] — practical read/write usage.
