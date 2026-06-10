---
title: Writing a Handler
category: guide
sources: [lib/src/handler/p_request_handler.dart]
last_updated: 2026-06-10
related: [narrative/modules/request-handlers, narrative/concepts/request-validation, narrative/concepts/server-plug-contract]
covers_packages: [pluggable_dart_server]
---

# Writing a Handler

A handler subclasses `PRequestHandler` and overrides the HTTP method(s) it supports.

## A GET handler

```dart
class GreetingHandler extends PRequestHandler {
  GreetingHandler(super.args);

  @override
  FutureOr<Object?> get() async {
    return {'message': 'Hello, World!'};
  }
}
```

The returned object is serialized into a `PHttpResponse` automatically; primitives and maps are handled directly.

## Adding validation

Attach validators at construction so they run before your method hook:

```dart
GreetingHandler(
  request: req,
  queryValidator: QueryParamValidator(/* rules */),
  headerValidator: HeaderValidator(/* rules */),
);
```

Validation failures are captured as exceptions and turned into an error response — see [[narrative/concepts/request-validation]].

## Dispatch

The active server plug calls your handler through its `handle` method: it builds the handler from the incoming request and calls `execute()`. You never wire sockets or routing yourself — that belongs to the server plug (see [[narrative/concepts/server-plug-contract]]).

## See Also

- [[narrative/modules/request-handlers]] — the handler lifecycle.
- [[narrative/concepts/request-validation]] — validator details.
- [[narrative/concepts/server-plug-contract]] — how handlers are dispatched.
