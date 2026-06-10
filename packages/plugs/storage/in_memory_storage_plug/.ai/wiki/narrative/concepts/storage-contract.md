---
title: Storage Contract
category: concept
sources: [lib/in_memory_storage_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/in-memory-storage-plug, narrative/guides/using-the-storage-plug]
covers_packages: [in_memory_storage_plug]
---

# Storage Contract

The framework defines storage as an abstract `PluggableStorageProvider`. Every storage plug — including `InMemoryStoragePlug` — implements this contract, which is why backends are interchangeable behind a `PluggableStorage`.

## The contract

`PluggableStorageProvider` declares a key/value contract over typed sessions. The concrete provider implements:

- `open<T>` / `close<T>` — open or close a per-type storage session.
- `get<T>` / `put<T>` / `putIfAbsent<T>` / `getAndPut<T>` — read and write typed values, with an optional fetch fallback and trace id on reads.
- `containsKey<T>` / `keys<T>` / `getAllForType` — inspect stored keys.
- `dump<T>` — drop a type's stored data.
- `init` / `dispose` — provider lifecycle (inherited from `Plug`).

Reads accept an optional `Fetch<T>` callback so a miss can be backfilled, and an optional `trace` string for diagnostics. The `InFlightMixin` (mixed into the base contract) de-duplicates concurrent in-flight reads for the same key.

## How `InMemoryStoragePlug` fulfils it

`InMemoryStoragePlug` maps these operations onto an in-process Dart map. Backend-specific behavior:

- Stores values in a nested `Map<Type, Map<String, Object?>>` keyed first by type then by key.
- No expiry, encryption, or external dependencies — the simplest possible provider.
- Used as the framework's default `local` and `remote` provider when no storage plug is supplied.

## See Also

- [[narrative/modules/in-memory-storage-plug]] — the implementing class.
- [[narrative/guides/using-the-storage-plug]] — using the contract in practice.
