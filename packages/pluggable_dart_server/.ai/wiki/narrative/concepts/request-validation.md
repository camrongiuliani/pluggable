---
title: Request Validation
category: concept
sources: [lib/src/validation/]
last_updated: 2026-06-10
related: [narrative/modules/request-handlers, narrative/guides/writing-a-handler]
covers_packages: [pluggable_dart_server]
---

# Request Validation

The binding provides a validation layer for HTTP query parameters and headers, applied by `PRequestHandler` before a method hook runs.

## Validators

- `QueryParamValidator` builds and runs a set of `QueryParamValidation<T>` rules over the request's query parameters.
- `HeaderValidator` builds and runs `HeaderValidation<T>` rules over the request headers.

Each validation is generic over the expected value type and chains validation operations (presence, type, custom checks) defined in `validation_operation.dart`.

## Failure model

Validation failures raise typed exceptions — `InvalidArgumentException` and `MissingRequiredArgumentException` — which the handler captures into its `exceptions` list and turns into an error response, rather than throwing past the handler boundary.

## Wiring

A handler receives optional `queryValidator` / `headerValidator` at construction; `execute()` runs them as part of request processing. The validation barrel (`validation.dart`) re-exports the header/query validators, operations, and exceptions.

For exact symbols, see [structure/manifest.json](../../structure/manifest.json).

## See Also

- [[narrative/modules/request-handlers]] — runs the validators.
- [[narrative/guides/writing-a-handler]] — attaching validators.
