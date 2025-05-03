# Pluggable Framework

A modular and extensible framework for building Flutter and Dart applications with a focus on flexibility and maintainability.

## Overview

Pluggable provides core abstractions and implementations for building modular applications. It supports both Flutter and pure Dart (including server) applications, with a focus on:

- **Modularity**: Break down your application into independent, reusable modules
- **Extensibility**: Easily add new functionality through plugins
- **Dependency Injection**: Manage dependencies and services
- **Navigation**: Handle routing and navigation with custom transitions
- **Storage**: Support for various storage backends
- **HTTP Server**: Server-side HTTP handling with support for different request types
- **Analytics**: Track user behavior and application metrics
- **Logging**: Comprehensive logging capabilities

## Example Project Structure

A typical project using Pluggable might be organized as follows:

- **core**: Shared business logic, models, and services
- **ui**: Flutter-based user interface, using Pluggable for navigation and theming
- **api**: Dart server application, using Pluggable for routing, dependency injection, and storage

## Getting Started

---

### Flutter Application Example

#### 1. Define a Core Module

```dart
// core_module.dart
import 'package:pluggable/pluggable.dart';

class CoreModule extends PluggableModule {
  @override
  void bind() {
    register<AnalyticsService>(() => AnalyticsServiceImpl());
    register<StorageService>(() => StorageServiceImpl());
    register<UserRepository>(() => UserRepositoryImpl());
  }
}
```

#### 2. Define a Feature Module

```dart
// feature_module.dart
import 'package:pluggable/pluggable.dart';

class FeatureModule extends PluggableModule {
  @override
  void bind() {
    register<FeatureService>(() => FeatureServiceImpl());
  }
}
```

#### 3. Set Up Navigation with Guards and Transitions

You can use either a custom navigation plugin or the GoRouterPlug for navigation.

**Option A: Using GoRouterPlug**

```dart
// main.dart
import 'package:pluggable_flutter/pluggable_flutter.dart';
import 'core_module.dart';
import 'feature_module.dart';

void main() {
  runPluggableApp(
    navigationPlugin: GoRouterPlug(
      initialRoute: '/login',
      routes: [
        PluggableRoute(
          path: '/login',
          builder: (context) => LoginPage(),
        ),
        PluggableRoute(
          path: '/dashboard',
          builder: (context) => DashboardPage(),
          guard: AuthGuard(),
        ),
      ],
    ),
    modules: [
      CoreModule(),
      FeatureModule(),
    ],
    storagePlugin: InMemoryStoragePlug(),
    theme: AppTheme.light(),
  );
}
```

**Option B: Using a Custom Navigation Plugin**

```dart
// navigation.dart
import 'package:pluggable_flutter/pluggable_flutter.dart';

final routes = [
  PluggableRoute(
    path: '/login',
    builder: (context) => LoginPage(),
    transition: RouteTransition.fade,
  ),
  PluggableRoute(
    path: '/dashboard',
    builder: (context) => DashboardPage(),
    transition: RouteTransition.slideLeft,
    guard: AuthGuard(), // Custom route guard
  ),
];

// main.dart
import 'package:pluggable_flutter/pluggable_flutter.dart';
import 'core_module.dart';
import 'feature_module.dart';
import 'navigation.dart';

void main() {
  runPluggableApp(
    navigationPlugin: CustomNavigationPlug(
      initialRoute: '/login',
      routes: routes,
    ),
    modules: [
      CoreModule(),
      FeatureModule(),
    ],
    storagePlugin: InMemoryStoragePlug(),
    theme: AppTheme.light(),
  );
}
```

#### 4. Use Dependency Injection in Widgets

```dart
// dashboard_page.dart
import 'package:pluggable_flutter/pluggable_flutter.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final analytics = Pluggable.of<AnalyticsService>(context);
    analytics.trackPageView('dashboard');
    // ...
    return Scaffold(
      // ...
    );
  }
}
```

---

### Dart Server Application Example

#### 1. Define API and Core Modules

```dart
// api_module.dart
import 'package:pluggable/pluggable.dart';

class ApiModule extends PluggableModule {
  @override
  void bind() {
    register<AuthService>(() => AuthServiceImpl());
    register<StorageService>(() => StorageServiceImpl());
  }
}
```

#### 2. Create a Handler

```dart
// resource_handler.dart
import 'package:pluggable/pluggable.dart';

class ResourceHandler extends PRequestHandler {
  ResourceHandler({
    required super.request,
  });

  @override
  Future<Response> get() async {
    final data = await storage.get('resource_key');
    return Response.ok(data);
  }

  @override
  Future<Response> post() async {
    final payload = await request.body();
    await storage.put('resource_key', payload);
    return Response.created('Resource created');
  }
}
```

#### 3. Set Up Route Handler

```dart
// routes/resource/index.dart
import 'package:dart_frog/dart_frog.dart';
import 'package:pluggable_dart_server/pluggable_dart_server.dart';
import 'resource_handler.dart';

Future<Response> onRequest(RequestContext context) async {
  return Pluggable.server.handle(
    request: context,
    handler: (request) => ResourceHandler(
      request: request,
    ),
  );
}
```

#### 4. Initialize the Server with DartFrogServerPlug

```dart
// main.dart
import 'dart:async';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:pluggable_dart_server/pluggable_dart_server.dart';
import 'package:dart_frog_server_plug/dart_frog_server_plug.dart';

import 'core_module.dart';
import 'api_module.dart';

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  final serverPath = Platform.environment['SERVER_PATH'] ?? '';

  return runPluggableServer(
    server: DartFrogServerPlug(
      internetAddress: ip,
      port: port,
      rootHandler: handler,
    ),
    modules: [
      CoreModule(),
      ApiModule(),
    ],
    mounts: [
      if (serverPath.isNotEmpty) serverPath,
      '/',
    ],
  );
}
```

---

## Advanced Features

### Custom Storage Plugins

```dart
class CustomStoragePlug extends PluggableStorage {
  // Implement custom storage logic here
}
```

### Analytics and Logging

```dart
final analytics = Pluggable.get<AnalyticsService>();
analytics.trackEvent('user_signup', properties: {'method': 'email'});

final logger = Pluggable.get<LoggerService>();
logger.info('User signed up successfully');
```

---

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

[Your License Here] 