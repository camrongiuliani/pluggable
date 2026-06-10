---
title: Server Binding
category: architecture
sources: [lib/pluggable_dart_server.dart, lib/src/pluggable_ext.dart]
last_updated: 2026-06-10
related: [narrative/modules/request-handlers, narrative/concepts/server-plug-contract]
covers_packages: [pluggable_dart_server]
---

# Server Binding

`pluggable_dart_server` is a binding: it adapts the stack-agnostic Pluggable core to an HTTP server runtime. It re-exports the core and layers server-specific types on top rather than redefining the plug system.

## Layering

- **Core** (`pluggable`) defines plug contracts (DI, storage, logging, mapping) and the module/plug lifecycle, with no server assumptions.
- **This binding** adds the request-handler base (`PRequestHandler`), validation, the `ServerModule` base, `ServerEnv`, a Dart `initPluggable`, and the `DartServerPlug` contract.
- **Server plugs** (e.g. `dart_frog_server_plug`) implement `DartServerPlug` with a concrete HTTP server.

## Re-export strategy

The barrel re-exports the core via `export 'package:pluggable/pluggable.dart' hide initPluggable;` and exposes the server plug contract, request handler, validation, server module, and server env. App code gets the full core API plus server additions from one import, with this package's Dart `initPluggable` shadowing the core one.

## Neutral request/response

Handlers work with the core's framework-neutral `PHttpRequest`/`PHttpResponse`. The server plug is responsible for mapping its native request/response objects to and from these types, so handler code stays independent of the server implementation.

## See Also

- [[narrative/modules/request-handlers]] — the handler base this binding adds.
- [[narrative/concepts/server-plug-contract]] — the contract this binding owns.
