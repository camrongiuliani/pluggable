---
title: Server Contract
category: concept
sources: [lib/dart_frog_server_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/dart-frog-server-plug, narrative/guides/running-the-server]
covers_packages: [dart_frog_server_plug]
---

# Server Contract

The Dart server binding defines the HTTP server as an abstract `DartServerPlug` (a `Plug`). `DartFrogServerPlug` implements this contract, which is why the server backend is interchangeable.

## The contract

`DartServerPlug` holds the listen `ip` and `port` and declares:

- `run({ip, port, mounts, poweredByHeader, securityContext, shared})` — start the HTTP server and return an `HttpServer`.
- `handle<REQUEST, RESPONSE>({request, handler})` — adapt a backend request, run a framework `PRequestHandler`, and adapt the response back.

A `RequestHandler` (typedef) maps a `PHttpRequest` to a `PRequestHandler` — the framework-neutral unit that produces a `PHttpResponse`. The contract is intentionally backend-agnostic: handlers operate on `PHttpRequest`/`PHttpResponse`, never on the underlying server's types.

## How `DartFrogServerPlug` fulfils it

`DartFrogServerPlug` backs `run` with a `dart_frog` `Router` + `serve`, and `handle` with async request mapping, handler `execute()`, and response mapping. See [[narrative/concepts/request-response-mapping]].

## See Also

- [[narrative/modules/dart-frog-server-plug]] — the implementing class.
- [[narrative/concepts/request-response-mapping]] — the type adaptation.
