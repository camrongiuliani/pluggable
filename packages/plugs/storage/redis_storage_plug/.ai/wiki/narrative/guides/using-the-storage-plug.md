---
title: Using the Storage Plug
category: guide
sources: [lib/redis_storage_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/redis-storage-plug, narrative/concepts/storage-contract]
covers_packages: [redis_storage_plug]
---

# Using the Storage Plug

`RedisStoragePlug` plugs into the framework as a storage provider. It is suitable for server-side or multi-instance apps using Redis as a shared store.

## Installing the plug

Provide it as the `local` and/or `remote` provider of a `PluggableStorage` at app init:

```dart
await initPluggable(
  storagePlugin: PluggableStorage(
    local: RedisStoragePlug(),
    remote: RedisStoragePlug(),
  ),
  modules: [/* ... */],
);
```

## Reading and writing

Through any `PluggableStorageProvider` (e.g. `Pluggable.storage.local`):

```dart
await provider.open<User>(expiry: const Duration(hours: 1));
await provider.put<User>('me', user);
final me = await provider.get<User>('me');           // null if absent
final loaded = await provider.get<User>('me', fetchUser); // backfill on miss
final exists = await provider.containsKey<User>('me');
```

`get` accepts an optional `Fetch<T>` to populate a missing entry, and an optional `trace` id for diagnostics. Concurrent reads of the same key are de-duplicated by the contract's `InFlightMixin`.

## Notes

- Persistence: persistent and shareable across processes.
- For the exact method signatures, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/modules/redis-storage-plug]] — backend mapping.
- [[narrative/concepts/storage-contract]] — the contract semantics.
