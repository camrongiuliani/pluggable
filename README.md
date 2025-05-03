# Pluggable Framework

A modular and extensible framework for building Flutter and Dart applications with a focus on flexibility and maintainability.

## Overview

Pluggable provides core abstractions and implementations for building modular applications. It supports both Flutter and pure Dart (including server) applications, with a focus on:

- **Modularity**: Break down your application into independent, reusable modules
- **Extensibility**: Easily add new functionality through plugins
- **Dependency Injection**: Manage dependencies and services
- **Navigation**: Handle routing and navigation with custom transitions
- **Storage**: Support for various storage backends
- **HTTP**: Flexible HTTP client with support for different request types
- **Analytics**: Track user behavior and application metrics
- **Logging**: Comprehensive logging capabilities

## Example Project Structure

A typical project using Pluggable might be organized as follows:

- **core**: Shared business logic, models, and services
- **ui**: Flutter-based user interface, using Pluggable for navigation, theming, and state management
- **api**: Dart server application, using Pluggable for routing, dependency injection, and storage

## Getting Started

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
```

#### 4. Initialize the App

```dart
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

#### 5. Use Dependency Injection in Widgets

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
    register<ApiController>(() => ApiControllerImpl());
    register<AuthService>(() => AuthServiceImpl());
  }
}
```

#### 2. Set Up Server Routes

```dart
// server_routes.dart
import 'package:pluggable/pluggable.dart';

final apiRoutes = [
  PluggableRoute(
    path: '/api/v1/resource',
    method: HttpMethod.get,
    handler: (context) async {
      final controller = context.get<ApiController>();
      return controller.getResource(context.request);
    },
    guard: ApiAuthGuard(),
  ),
  PluggableRoute(
    path: '/api/v1/resource',
    method: HttpMethod.post,
    handler: (context) async {
      final controller = context.get<ApiController>();
      return controller.createResource(context.request);
    },
  ),
];
```

#### 3. Initialize the Server

```dart
// main.dart
import 'package:pluggable/pluggable.dart';
import 'core_module.dart';
import 'api_module.dart';
import 'server_routes.dart';

void main() async {
  final pluggable = await initPluggable(
    modules: [
      CoreModule(),
      ApiModule(),
    ],
    storagePlugin: RedisStoragePlug(connectionString: 'redis://localhost:6379'),
    routes: apiRoutes,
  );

  // Start the HTTP server
  await pluggable.get<ServerService>().start(port: 8080);
}
```

#### 4. Use Dependency Injection in Controllers

```dart
// api_controller.dart
import 'package:pluggable/pluggable.dart';

class ApiControllerImpl implements ApiController {
  final StorageService storage;
  final AnalyticsService analytics;

  ApiControllerImpl()
      : storage = Pluggable.get<StorageService>(),
        analytics = Pluggable.get<AnalyticsService>();

  Future<Response> getResource(Request request) async {
    analytics.trackEvent('get_resource');
    final data = await storage.get('resource_key');
    return Response.ok(data);
  }

  Future<Response> createResource(Request request) async {
    final payload = await request.body();
    await storage.put('resource_key', payload);
    analytics.trackEvent('create_resource');
    return Response.created('Resource created');
  }
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

### HTTP Client Usage

```dart
final response = await PHttpRequest.post(
  'https://api.example.com/data',
  body: {'name': 'example'},
  headers: {'Authorization': 'Bearer token'},
  cache: true,
);
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