---
title: InMemoryStoragePlug
category: module
sources: [lib/in_memory_storage_plug.dart]
last_updated: 2026-06-10
related: [narrative/concepts/storage-contract, narrative/guides/using-the-storage-plug]
covers_packages: [in_memory_storage_plug]
---

# InMemoryStoragePlug

`InMemoryStoragePlug` is the public class of this package. It extends `PluggableStorageProvider` and provides ephemeral in-memory storage backed by an in-process Dart map.

## Role

The framework models storage as a swappable provider behind the `PluggableStorageProvider` contract. `InMemoryStoragePlug` is one concrete backend; an app selects it (as `local` and/or `remote`) when constructing a `PluggableStorage`, and module code reads/writes through the abstract contract without knowing the backend. Storage is non-persistent (cleared on process exit).

## Backend specifics

- Stores values in a nested `Map<Type, Map<String, Object?>>` keyed first by type then by key.
- No expiry, encryption, or external dependencies — the simplest possible provider.
- Used as the framework's default `local` and `remote` provider when no storage plug is supplied.

## Contract it satisfies

See [[narrative/concepts/storage-contract]] for the full method set. For the exact symbol inventory of this package, see [structure/manifest.json](../../structure/manifest.json). The contract type itself is defined by the framework core (`pluggable`).

## See Also

- [[narrative/concepts/storage-contract]] — the contract this class implements.
- [[narrative/guides/using-the-storage-plug]] — practical read/write usage.
