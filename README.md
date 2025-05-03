# Pluggable Framework

A modular and extensible framework for building Flutter and Dart applications with a focus on flexibility and maintainability.

## Overview

Pluggable is a framework that provides a set of core abstractions and implementations for building modular applications. It supports both Flutter and pure Dart applications, with a focus on:

- **Modularity**: Break down your application into independent, reusable modules
- **Extensibility**: Easily add new functionality through plugins
- **Dependency Injection**: Manage dependencies and services
- **Navigation**: Handle routing and navigation with custom transitions
- **Storage**: Support for various storage backends
- **HTTP**: Flexible HTTP client with support for different request types
- **Analytics**: Track user behavior and application metrics
- **Logging**: Comprehensive logging capabilities

## Packages

The framework is organized into several packages:

### Core Packages

- **pluggable**: The core package containing base abstractions and implementations
- **pluggable_flutter**: Flutter-specific extensions and implementations
- **pluggable_dart_server**: Server-side implementations for Dart applications

### Plugin Packages

- **plugs/navigator**: Navigation plugins for different routing implementations
- **plugs/storage**: Storage plugins for various backends (Redis, in-memory, etc.)
- **plugs/server**: Server plugins for different server implementations
- **plugs/mapper**: Data mapping plugins for object transformation
- **plugs/di**: Dependency injection plugins

## Getting Started

### Flutter Application

```dart
import 'package:pluggable_flutter/pluggable_flutter.dart';

void main() {
  runPluggableApp(
    navigationPlugin: GoRouterPlug(initialRoute: '/'),
    modules: [MyModule()],
    storagePlugin: InMemoryStoragePlug(),
    theme: ThemeData.light(),
  );
}
```

### Dart Application

```dart
import 'package:pluggable/pluggable.dart';

void main() async {
  final pluggable = await initPluggable(
    modules: [MyModule()],
    storagePlugin: InMemoryStoragePlug(),
  );
}
```

## Features

### Navigation

The framework provides a flexible navigation system with support for:

- Custom route transitions
- Nested navigation
- Route guards
- Query parameters
- Route data passing

```dart
final route = PluggableRoute(
  path: '/home',
  builder: (context) => HomePage(),
  transition: RouteTransition.slideLeft,
);
```

### Storage

Multiple storage backends are supported:

- In-memory storage
- Redis storage
- Expire cache storage

```dart
final storage = InMemoryStoragePlug();
await storage.put('key', 'value');
final value = await storage.get('key');
```

### HTTP

A flexible HTTP client with support for:

- Different HTTP methods
- Form data
- Query parameters
- Headers
- Cache control
- Response handling

```dart
final response = await PHttpRequest.get(
  'https://api.example.com/data',
  queryParams: {'page': '1'},
);
```

### Dependency Injection

Manage dependencies and services with:

- Service registration
- Dependency resolution
- Scoped services
- Factory methods

```dart
class MyModule extends PluggableModule {
  @override
  void bind() {
    register<MyService>(() => MyServiceImpl());
  }
}
```

## Documentation

Each package contains detailed documentation for its components. Key documentation files include:

- `pluggable.dart`: Core framework documentation
- `plug.dart`: Plugin system documentation
- `pluggable_module.dart`: Module system documentation
- `pluggable_http.dart`: HTTP client documentation
- `pluggable_navigator.dart`: Navigation system documentation
- `pluggable_storage.dart`: Storage system documentation

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting pull requests.

## License

 