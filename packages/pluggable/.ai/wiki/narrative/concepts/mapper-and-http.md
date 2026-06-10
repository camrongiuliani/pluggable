---
title: Mapper and HTTP Contracts
category: concept
sources: [lib/src/mapper/pluggable_mapper.dart, lib/src/http/pluggable_http.dart, lib/src/http/models/]
last_updated: 2026-06-10
related: [narrative/architecture/plug-system, narrative/modules/pluggable-module]
covers_packages: [pluggable]
---

# Mapper and HTTP Contracts

The core defines the object-mapping contract and a set of framework-neutral HTTP request/response models that bindings and plugs adapt to and from native types.

## `PluggableMapper`

`PluggableMapper` is a `Plug` that maintains a registry of mappers and converts objects by type. Representative members: `buildAtlas` (register a batch), `map` / `maybeMap` / `mapAsync` / `maybeMapAsync` (convert), `isMapped` (existence). Mappers extend `Mapper<FROM, TO>` (sync `map`) or `AsyncMapper<FROM, TO>` (async `mapAsync`). Modules contribute mappers through their `registerMappers` hook (see [[narrative/modules/pluggable-module]]); the default implementation is `CartographerMapperPlug`. A missing mapper raises a `MapperNotRegistered` exception.

## HTTP models

The `http/` directory defines neutral request/response types used across server and client boundaries so handler/telemetry code does not depend on a specific HTTP library. Representative models: `PHttpRequest`, `PHttpResponse`, `PHttpMethod`, `PFormData`, `PFormFile`, plus typed request variants (JSON, bytes, form-data) and `HttpStatusCode`/`CacheControl`. There is also a `PHttpClient` / client-adapter abstraction.

For the full model and member inventory, see [structure/models.md](../../structure/models.md) and [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/architecture/plug-system]] — mapper is a contract.
- [[narrative/modules/pluggable-module]] — modules register mappers.
