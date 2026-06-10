---
title: Server Plug Contract
category: concept
sources: [lib/src/plugs/dart_server_plug.dart]
last_updated: 2026-06-10
related: [narrative/architecture/server-binding, narrative/modules/request-handlers]
covers_packages: [pluggable_dart_server]
---

# Server Plug Contract

This binding defines the HTTP server as an abstract `DartServerPlug` (a `Plug`). Concrete server plugs implement it; the binding's handlers run inside whatever server the plug provides.

## The contract

`DartServerPlug` holds the listen `ip` and `port` and declares:

- `run({ip, port, mounts, poweredByHeader, securityContext, shared})` — start the server, return an `HttpServer`.
- `handle<REQUEST, RESPONSE>({request, handler})` — adapt the server's native request, invoke a `RequestHandler`, and adapt the result back.

The `RequestHandler` typedef maps a `PHttpRequest` to a `PRequestHandler` — the unit of work the binding defines (see [[narrative/modules/request-handlers]]). Because the contract is backend-agnostic, handler code never touches the server's native types.

## Who implements it

A server plug supplies the concrete server. In this monorepo, `dart_frog_server_plug` implements `DartServerPlug` over `dart_frog`, mapping `RequestContext`/`Response` to and from `PHttpRequest`/`PHttpResponse`. Any conforming server can be installed instead.

For exact symbols, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/architecture/server-binding]] — where the contract sits.
- [[narrative/modules/request-handlers]] — the handlers the contract dispatches.
