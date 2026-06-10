---
title: Running the Server
category: guide
sources: [lib/dart_frog_server_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/dart-frog-server-plug, narrative/concepts/server-contract, narrative/concepts/request-response-mapping]
covers_packages: [dart_frog_server_plug]
---

# Running the Server

`DartFrogServerPlug` is the server backend for a Pluggable Dart server app.

## Constructing the plug

```dart
final server = DartFrogServerPlug(
  rootHandler: myRootHandler,                 // a dart_frog Handler
  internetAddress: InternetAddress.anyIPv4,
  port: 8080,
);
```

## Starting the server

```dart
await server.init();      // registers request/response mappers
final httpServer = await server.run(
  ip: InternetAddress.anyIPv4,
  port: 8080,
  mounts: ['/'],          // mount the root handler at these paths
);
```

`run` returns the `HttpServer`. The default `poweredByHeader` is `Dart Pluggable`; pass your own (or a `securityContext`) as needed.

## Handling requests

Each request is dispatched through `handle`, which converts the Dart Frog `RequestContext` to a `PHttpRequest`, runs your framework `PRequestHandler`, converts the result back to a `Response`, and adds an `x-request-id` header. You write `PRequestHandler`s against neutral types — see [[narrative/concepts/request-response-mapping]].

## See Also

- [[narrative/modules/dart-frog-server-plug]] — class behavior.
- [[narrative/concepts/server-contract]] — the operations.
- [[narrative/concepts/request-response-mapping]] — type adaptation.
