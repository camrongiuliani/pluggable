# dart_frog_server_plug — Overview

`dart_frog_server_plug` is the server plug for the Pluggable plug-n-play framework's Dart server binding. It implements the framework's `DartServerPlug` contract on top of [`dart_frog`](https://pub.dev/packages/dart_frog): it runs an HTTP server, mounts a root handler, and dispatches each request to a framework `PRequestHandler`.

A "plug" satisfies an abstract contract so it can be swapped without changing application code. `DartFrogServerPlug` is the server backend a Pluggable Dart server app installs. Because requests and responses cross the boundary as framework-neutral `PHttpRequest`/`PHttpResponse`, handler code never depends on Dart Frog types — this plug adapts them through registered mappers.

This wiki is self-contained: it explains the plug, the server contract it satisfies, and the request/response mapping bridge, without requiring any other package's wiki.

## Narrative layer

- [[narrative/modules/dart-frog-server-plug]] — the `DartFrogServerPlug` class: serving and request dispatch.
- [[narrative/concepts/server-contract]] — the `DartServerPlug` contract this plug satisfies.
- [[narrative/concepts/request-response-mapping]] — how Dart Frog `RequestContext`/`Response` map to `PHttpRequest`/`PHttpResponse`.
- [[narrative/guides/running-the-server]] — configuring and running the server.

## Structure layer

- [structure/README.md](structure/README.md) — generation banner.
- [structure/manifest.json](structure/manifest.json) — machine-readable symbol index.
- [structure/libraries.md](structure/libraries.md) — dependency inventory.
- [structure/blast.md](structure/blast.md), [structure/hotspots.md](structure/hotspots.md).

## Which layer answers which question

| Question | Layer |
|---|---|
| "Where is `run`/`handle` defined?" | `structure/manifest.json` |
| "What does this plug depend on?" | `structure/libraries.md` |
| "What server operations exist?" | `narrative/concepts/server-contract` |
| "How are requests/responses mapped?" | `narrative/concepts/request-response-mapping` |
| "How do I run the server?" | `narrative/guides/running-the-server` |
