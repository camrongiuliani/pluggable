---
title: SecureStoragePlug
category: module
sources: [lib/secure_storage_plug.dart]
last_updated: 2026-06-10
related: [narrative/concepts/storage-contract, narrative/guides/using-the-storage-plug]
covers_packages: [secure_storage_plug]
---

# SecureStoragePlug

`SecureStoragePlug` is the public class of this package. It extends `PluggableStorageProvider` and provides persistent encrypted on-device storage backed by encrypted Hive (via `stash` + `stash_hive`).

## Role

The framework models storage as a swappable provider behind the `PluggableStorageProvider` contract. `SecureStoragePlug` is one concrete backend; an app selects it (as `local` and/or `remote`) when constructing a `PluggableStorage`, and module code reads/writes through the abstract contract without knowing the backend. Storage is persistent and encrypted at rest.

## Backend specifics

- Builds a `stash` store over an encrypted Hive box; `init` provisions the encrypted store.
- Each stored type opens its own encrypted vault lazily through `open`.
- Uses `synchronized` for concurrency and `uuid` for internal keying.

## Contract it satisfies

See [[narrative/concepts/storage-contract]] for the full method set. For the exact symbol inventory of this package, see [structure/manifest.json](../../structure/manifest.json). The contract type itself is defined by the framework core (`pluggable`).

## See Also

- [[narrative/concepts/storage-contract]] — the contract this class implements.
- [[narrative/guides/using-the-storage-plug]] — practical read/write usage.
