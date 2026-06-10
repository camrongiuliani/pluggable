---
title: DartFrogServerPlug
category: module
sources: [lib/dart_frog_server_plug.dart]
last_updated: 2026-06-10
related: [narrative/concepts/server-contract, narrative/concepts/request-response-mapping, narrative/guides/running-the-server]
covers_packages: [dart_frog_server_plug]
---

# DartFrogServerPlug

`DartFrogServerPlug` is the server implementation of this package. It extends `DartServerPlug` and runs an HTTP server using `dart_frog`, dispatching requests to framework `PRequestHandler`s.

## Role

The Dart server binding models the HTTP server as a swappable `DartServerPlug` contract. `DartFrogServerPlug` is one backend; an app installs it and works through the abstract contract, so the underlying server (Dart Frog here) can be replaced without touching handler logic.

## Construction

Constructed with a `rootHandler` (a `dart_frog` `Handler`), an `InternetAddress`, and a `port`. The address and port are passed to the `DartServerPlug` superclass.

## Behavior

- `init` registers this package's request and response mappers into the framework mapper via `buildAtlas` (see [[narrative/concepts/request-response-mapping]]).
- `run` builds a `dart_frog` `Router`, mounts the `rootHandler` at each configured mount path, and calls `serve` with the IP, port, and a `poweredByHeader` defaulting to `Dart Pluggable`.
- `handle<REQUEST, RES>` adapts an incoming `RequestContext` to a `PHttpRequest` (async map), invokes the framework handler's `execute()`, maps the resulting `PHttpResponse` back to a Dart Frog `Response`, and injects an `x-request-id` header.

For exact signatures, see [structure/manifest.json](../../structure/manifest.json). The contract types are defined by the binding (`pluggable_dart_server`).

## See Also

- [[narrative/concepts/server-contract]] — the contract this class implements.
- [[narrative/concepts/request-response-mapping]] — the mapper bridge.
- [[narrative/guides/running-the-server]] — configuring and running.
