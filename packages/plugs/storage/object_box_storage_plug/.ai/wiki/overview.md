# object_box_storage_plug — Overview

`object_box_storage_plug` is a storage plug for the Pluggable plug-n-play framework. It provides persistent on-device storage backed by the ObjectBox NoSQL database by implementing the framework's `PluggableStorageProvider` contract over ObjectBox (via `stash` + `stash_objectbox`).

A "plug" satisfies an abstract contract so it can be swapped without changing application code. `ObjectBoxStoragePlug` can be used as the `local` and/or `remote` provider inside a `PluggableStorage`. Suitable for mobile/desktop apps needing fast persistent local storage.

This wiki is self-contained: it explains the plug, the storage contract it satisfies, and how to use it, without requiring any other package's wiki.

## Narrative layer

- [[narrative/modules/object-box-storage-plug]] — the `ObjectBoxStoragePlug` class and how it maps the contract onto its backend.
- [[narrative/concepts/storage-contract]] — the `PluggableStorageProvider` key/value contract this plug satisfies.
- [[narrative/guides/using-the-storage-plug]] — installing and using the plug.

## Structure layer

- [structure/README.md](structure/README.md) — generation banner.
- [structure/manifest.json](structure/manifest.json) — machine-readable symbol index.
- [structure/libraries.md](structure/libraries.md) — dependency inventory.
- [structure/blast.md](structure/blast.md), [structure/hotspots.md](structure/hotspots.md) — high-impact files and entry points.

## Which layer answers which question

| Question | Layer |
|---|---|
| "Where is `get`/`put` defined?" | `structure/manifest.json` |
| "What does this plug depend on?" | `structure/libraries.md` |
| "Why is storage a swappable provider?" | `narrative/concepts/storage-contract` |
| "How do I read/write a value?" | `narrative/guides/using-the-storage-plug` |
| "What backend does this use?" | `narrative/modules/object-box-storage-plug` |
