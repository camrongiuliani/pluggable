---
title: DI Scopes
category: concept
sources: [lib/pluggable_di_getit.dart]
last_updated: 2026-06-10
related: [narrative/modules/pluggable-getit, narrative/guides/using-the-di-plug]
covers_packages: [pluggable_di_getit]
---

# DI Scopes

A DI scope is a named layer of registrations stacked on top of the base container. Resolving a type checks the top scope first and falls through to lower scopes, so a scope can override or add registrations without affecting the layers beneath it.

## Why scopes matter

Pluggable modules are self-contained units that register their own dependencies when bound and tear them down when unbound. Scopes give each module an isolated namespace: a module pushes a uniquely-named scope on bind and pops it on unbind, so its registrations appear and disappear as a unit and cannot leak into or clobber other modules.

## How `PluggableGetIt` implements scopes

`PluggableGetIt` maps the contract's scope operations onto `get_it`'s scope stack:

- `pushScope(name)` → `pushNewScope`, then logs the push through the framework logger.
- `popScope(name)` → `dropScope`, guarded by `hasScope` so popping an absent scope is a no-op.
- `replaceScope(name)` → pop-then-push if the scope already exists.
- `containsScope(name)` → `hasScope`.

Scope names are supplied by the caller. Modules in the framework derive a stable per-instance key for their scope name.

## See Also

- [[narrative/modules/pluggable-getit]] — the class implementing these operations.
- [[narrative/guides/using-the-di-plug]] — practical registration/resolution.
