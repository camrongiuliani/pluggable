---
title: Storage Contract
category: concept
sources: [lib/secure_storage_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/secure-storage-plug, narrative/guides/using-the-storage-plug]
covers_packages: [secure_storage_plug]
---

# Storage Contract

The framework defines storage as an abstract `PluggableStorageProvider`. Every storage plug — including `SecureStoragePlug` — implements this contract, which is why backends are interchangeable behind a `PluggableStorage`.

## The contract

`PluggableStorageProvider` declares a key/value contract over typed sessions. The concrete provider implements:

- `open<T>` / `close<T>` — open or close a per-type storage session.
- `get<T>` / `put<T>` / `putIfAbsent<T>` / `getAndPut<T>` — read and write typed values, with an optional fetch fallback and trace id on reads.
- `containsKey<T>` / `keys<T>` / `getAllForType` — inspect stored keys.
- `dump<T>` — drop a type's stored data.
- `init` / `dispose` — provider lifecycle (inherited from `Plug`).

Reads accept an optional `Fetch<T>` callback so a miss can be backfilled, and an optional `trace` string for diagnostics. The `InFlightMixin` (mixed into the base contract) de-duplicates concurrent in-flight reads for the same key.

## How `SecureStoragePlug` fulfils it

`SecureStoragePlug` maps these operations onto encrypted Hive (via `stash` + `stash_hive`). Backend-specific behavior:

- Builds a `stash` store over an encrypted Hive box; `init` provisions the encrypted store.
- Each stored type opens its own encrypted vault lazily through `open`.
- Uses `synchronized` for concurrency and `uuid` for internal keying.

## See Also

- [[narrative/modules/secure-storage-plug]] — the implementing class.
- [[narrative/guides/using-the-storage-plug]] — using the contract in practice.
