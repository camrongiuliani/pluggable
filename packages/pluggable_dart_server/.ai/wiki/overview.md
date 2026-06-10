# pluggable_dart_server — Overview

`pluggable_dart_server` is the Dart server binding of the Pluggable plug-n-play framework. It adapts the framework core to HTTP servers: it defines the request-handler base (`PRequestHandler`), a query/header validation system, a server-aware module base (`ServerModule`), server environment config, and the `DartServerPlug` contract that concrete server plugs implement.

The framework is layered: a stack-agnostic core defines plug contracts and the module lifecycle; bindings like this one adapt the core to a runtime (an HTTP server); and plugs supply concrete implementations. `pluggable_dart_server` is the server-side binding — handlers process framework-neutral `PHttpRequest`s and produce `PHttpResponse`s, while a server plug (e.g. `dart_frog_server_plug`) owns the actual socket and request dispatch.

This wiki is self-contained: it explains the request-handler model, validation, the server module, and the server contract this package owns, without requiring any other package's wiki.

## Narrative layer

- [[narrative/architecture/server-binding]] — how this package binds the core to HTTP servers and the layering.
- [[narrative/modules/request-handlers]] — the `PRequestHandler` lifecycle and per-method hooks.
- [[narrative/concepts/request-validation]] — query and header validation.
- [[narrative/concepts/server-plug-contract]] — the `DartServerPlug` contract this package owns.
- [[narrative/guides/writing-a-handler]] — implementing a handler with validation.

## Structure layer

- [structure/README.md](structure/README.md) — generation banner.
- [structure/manifest.json](structure/manifest.json) — machine-readable symbol index.
- [structure/models.md](structure/models.md) / [structure/libraries.md](structure/libraries.md).
- [structure/blast.md](structure/blast.md), [structure/hotspots.md](structure/hotspots.md).

## Which layer answers which question

| Question | Layer |
|---|---|
| "Where is `PRequestHandler`/`DartServerPlug` defined?" | `structure/manifest.json` |
| "What validators exist?" | `structure/manifest.json` |
| "What does this package depend on?" | `structure/libraries.md` |
| "How does a handler run?" | `narrative/modules/request-handlers` |
| "What must a server plug implement?" | `narrative/concepts/server-plug-contract` |
| "How do I write a handler?" | `narrative/guides/writing-a-handler` |
