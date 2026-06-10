---
title: Request Handlers
category: module
sources: [lib/src/handler/p_request_handler.dart, lib/src/module/server_module.dart]
last_updated: 2026-06-10
related: [narrative/concepts/request-validation, narrative/concepts/server-plug-contract, narrative/guides/writing-a-handler]
covers_packages: [pluggable_dart_server]
---

# Request Handlers

`PRequestHandler` is the base class for handling an HTTP request in a Pluggable server. A subclass overrides the HTTP-method hooks it supports; the base handles validation, response building, error capture, and serialization.

## Construction

A handler is built with the `PHttpRequest` it serves and optional `queryValidator` / `headerValidator` instances. On creation it logs a verbose trace tagged with the request id.

## Per-method hooks

Override the method(s) your route supports — `get`, `delete`, `head`, and the other standard verbs. Each returns a `FutureOr<Object?>`; the default implementations throw `UnimplementedError` so unsupported methods surface clearly.

## Execution

`execute()` runs the handler end to end via the internal `_execute()`:

- Runs validators and collects `PHttpException`s.
- Dispatches to the matching method hook.
- Serializes the returned object (primitive detection via `isPrimitiveDartType`) into a `PHttpResponse`.
- Routes errors through the `error()` hook and the captured exception list.

Response headers can be set through `addResponseHeader` / `removeResponseHeader` / `clearResponseHeaders`.

## ServerModule

`ServerModule` is a thin `PluggableModule` subclass for server-side modules; its `init` returns the module, and it inherits the core module lifecycle (dependency/mapper registration, scoped binding).

For exact signatures, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/concepts/request-validation]] — the validators a handler runs.
- [[narrative/concepts/server-plug-contract]] — how handlers are dispatched.
- [[narrative/guides/writing-a-handler]] — a worked handler.
