---
title: Using the Storage Plug
category: guide
sources: [lib/object_box_storage_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/object-box-storage-plug, narrative/concepts/storage-contract]
covers_packages: [object_box_storage_plug]
---

# Using the Storage Plug

`ObjectBoxStoragePlug` plugs into the framework as a storage provider. It is suitable for mobile/desktop apps needing fast persistent local storage.

## Installing the plug

Provide it as the `local` and/or `remote` provider of a `PluggableStorage` at app init:

```dart
await initPluggable(
  storagePlugin: PluggableStorage(
    local: ObjectBoxStoragePlug(),
    remote: ObjectBoxStoragePlug(),
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

- Persistence: persistent across app restarts.
- For the exact method signatures, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/modules/object-box-storage-plug]] — backend mapping.
- [[narrative/concepts/storage-contract]] — the contract semantics.
