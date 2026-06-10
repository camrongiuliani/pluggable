---
title: Using the DI Plug
category: guide
sources: [lib/pluggable_di_getit.dart]
last_updated: 2026-06-10
related: [narrative/modules/pluggable-getit, narrative/concepts/di-scopes]
covers_packages: [pluggable_di_getit]
---

# Using the DI Plug

`PluggableGetIt` is installed as the default DI plug by the framework's `initPluggable`, so most apps never construct it directly. To use a custom configuration or substitute another `PluggableDI`, pass it explicitly at init time.

## Registering dependencies

Inside a module's dependency-registration hook you receive a `PluggableDI` instance:

```dart
void addDependencies(PluggableDI i) {
  // Eager singleton — constructed immediately.
  i.addSingleton<ApiClient>(() => ApiClient());

  // Lazy singleton — constructed on first resolve.
  i.addLazySingleton<Repo>(() => Repo(i.get<ApiClient>()));

  // Named registration with a dispose callback.
  i.addSingleton<Db>(() => Db(), dispose: (db) => db.close(), name: 'primary');
}
```

## Resolving dependencies

```dart
final repo = i.get<Repo>();          // throws StateError if missing
final maybe = i.maybeGet<Repo>();    // null if missing
```

Use `get` when the dependency is required (a missing one is a configuration bug); use `maybeGet` when absence is a valid state.

## Reassignment

By default re-registering a type throws. Call `allowReassignment()` to permit overwriting existing registrations — useful in tests where you swap a real dependency for a fake.

## Scopes

Scope management (`pushScope` / `popScope` / `replaceScope`) is normally driven by the framework's module lifecycle; you rarely call it by hand. See [[narrative/concepts/di-scopes]].

## See Also

- [[narrative/modules/pluggable-getit]] — method-to-`get_it` mapping.
- [[narrative/concepts/di-scopes]] — scope semantics.
