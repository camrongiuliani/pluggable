---
title: Request/Response Mapping
category: concept
sources: [lib/mappers/request_mapper.dart, lib/mappers/response_mapper.dart]
last_updated: 2026-06-10
related: [narrative/modules/dart-frog-server-plug, narrative/concepts/server-contract]
covers_packages: [dart_frog_server_plug]
---

# Request/Response Mapping

Framework handlers operate on neutral `PHttpRequest`/`PHttpResponse` objects, but `dart_frog` speaks `RequestContext`/`Response`. This package bridges the two with mappers registered into the framework mapper.

## Request mappers

`FrogRequestMapper` is an `AsyncMapper<RequestContext, PHttpRequest>` that resolves the request body/data and builds a `PHttpRequest`. Its `all(mapper)` factory returns the full mapper set it depends on:

- `FrogRequestMapper` — the top-level request adapter.
- `HttpMethodMapper` — Dart Frog HTTP method to framework method.
- `FormDataMapper` / `FormFileMapper` — multipart form data and file parts.

## Response mapper

`FrogResponseMapper` maps a framework `PHttpResponse` back to a `dart_frog` `Response`.

## Registration

`DartFrogServerPlug.init` registers these via `Pluggable.mapper.buildAtlas([...FrogRequestMapper.all(mapper), FrogResponseMapper(mapper)])`. After init, `handle` uses `mapAsync<RequestContext, PHttpRequest>` on the way in and `map<PHttpResponse, Response>` on the way out.

For exact symbols, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/modules/dart-frog-server-plug]] — registers and uses these mappers.
- [[narrative/concepts/server-contract]] — why types are kept neutral.
