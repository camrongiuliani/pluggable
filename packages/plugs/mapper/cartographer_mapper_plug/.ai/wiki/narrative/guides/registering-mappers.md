---
title: Registering Mappers
category: guide
sources: [lib/cartographer_mapper_plug.dart]
last_updated: 2026-06-10
related: [narrative/modules/cartographer-mapper-plug, narrative/concepts/mapper-registry]
covers_packages: [cartographer_mapper_plug]
---

# Registering Mappers

`CartographerMapperPlug` is installed as the default mapper by `initPluggable`, so apps rarely construct it directly. To use a custom mapper backend, pass it as `mapperPlugin` at init.

## Defining a mapper

```dart
class UserDtoToUser extends Mapper<UserDto, User> {
  const UserDtoToUser() : super(UserDto, User);
  @override
  User map(UserDto source) => User(id: source.id, name: source.name);
}
```

For asynchronous conversions, extend `AsyncMapper<FROM, TO>` and implement `mapAsync`.

## Registering mappers

Modules expose their mappers through their `registerMappers` hook; the framework feeds them to the active mapper via `buildAtlas`:

```dart
@override
List<Mapper> registerMappers(PluggableMapper cartograph) => [
  const UserDtoToUser(),
];
```

## Invoking a conversion

```dart
final user = Pluggable.mapper.map<UserDto, User>(dto);        // throws if unregistered
final maybe = Pluggable.mapper.maybeMap<UserDto, User>(dto);  // null if unregistered
final async = await Pluggable.mapper.mapAsync<Raw, Parsed>(raw);
```

Pass a `named` argument when more than one mapper exists for the same type pair.

## See Also

- [[narrative/modules/cartographer-mapper-plug]] — the registry implementation.
- [[narrative/concepts/mapper-registry]] — lookup semantics.
