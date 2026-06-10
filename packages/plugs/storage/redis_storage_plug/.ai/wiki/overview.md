# redis_storage_plug — Overview

`redis_storage_plug` is a storage plug for the Pluggable plug-n-play framework. It provides remote/shared storage backed by Redis by implementing the framework's `PluggableStorageProvider` contract over a Redis server (via the `redis` package).

A "plug" satisfies an abstract contract so it can be swapped without changing application code. `RedisStoragePlug` can be used as the `local` and/or `remote` provider inside a `PluggableStorage`. Suitable for server-side or multi-instance apps using Redis as a shared store.

This wiki is self-contained: it explains the plug, the storage contract it satisfies, and how to use it, without requiring any other package's wiki.

## Narrative layer

- [[narrative/modules/redis-storage-plug]] — the `RedisStoragePlug` class and how it maps the contract onto its backend.
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
| "What backend does this use?" | `narrative/modules/redis-storage-plug` |
