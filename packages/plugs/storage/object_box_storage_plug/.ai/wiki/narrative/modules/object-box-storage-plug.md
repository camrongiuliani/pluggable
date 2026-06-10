---
title: ObjectBoxStoragePlug
category: module
sources: [lib/object_box_storage_plug.dart]
last_updated: 2026-06-10
related: [narrative/concepts/storage-contract, narrative/guides/using-the-storage-plug]
covers_packages: [object_box_storage_plug]
---

# ObjectBoxStoragePlug

`ObjectBoxStoragePlug` is the public class of this package. It extends `PluggableStorageProvider` and provides persistent on-device storage backed by the ObjectBox NoSQL database backed by ObjectBox (via `stash` + `stash_objectbox`).

## Role

The framework models storage as a swappable provider behind the `PluggableStorageProvider` contract. `ObjectBoxStoragePlug` is one concrete backend; an app selects it (as `local` and/or `remote`) when constructing a `PluggableStorage`, and module code reads/writes through the abstract contract without knowing the backend. Storage is persistent across app restarts.

## Backend specifics

- Builds a `stash` store over ObjectBox; `init` provisions the underlying database directory.
- Each stored type gets its own vault opened lazily through `open`.
- Uses `synchronized` for safe concurrent vault access and `uuid` for internal keying.

## Contract it satisfies

See [[narrative/concepts/storage-contract]] for the full method set. For the exact symbol inventory of this package, see [structure/manifest.json](../../structure/manifest.json). The contract type itself is defined by the framework core (`pluggable`).

## See Also

- [[narrative/concepts/storage-contract]] — the contract this class implements.
- [[narrative/guides/using-the-storage-plug]] — practical read/write usage.
