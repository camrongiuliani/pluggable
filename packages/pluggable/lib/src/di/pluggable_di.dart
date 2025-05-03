/// Abstract base class for dependency injection in the Pluggable system.
/// 
/// This class defines the interface for a dependency injection container
/// that manages object lifecycle and scoping. It supports both singleton
/// and lazy singleton patterns, with optional disposal functions.
/// 
/// Example usage:
/// ```dart
/// class MyDI extends PluggableDI {
///   @override
///   void addSingleton<T extends Object>(
///     DependencyBuilder<T> constructor, {
///     DependencyDisposeFunc<T>? dispose,
///     String? name,
///   }) {
///     // Implementation
///   }
///   
///   // Other method implementations...
/// }
/// ```

import 'dart:async';

import 'package:pluggable/src/plug.dart';

/// Function type for dependency disposal
typedef DependencyDisposeFunc<T> = FutureOr Function(T param);

/// Function type for dependency construction
typedef DependencyBuilder<T> = T Function();

abstract class PluggableDI extends Plug<PluggableDI> {
  /// Allows reassignment of dependencies
  /// 
  /// This method should be called to enable overwriting existing
  /// dependencies with new ones.
  void allowReassignment();

  /// Gets a dependency of type [T]
  /// 
  /// Throws an exception if the dependency is not found
  T get<T extends Object>();

  /// Safely gets a dependency of type [T]
  /// 
  /// Returns null if the dependency is not found
  T? maybeGet<T extends Object>();

  /// Pushes a new dependency scope with the given name
  /// 
  /// [name] - The name of the new scope
  void pushScope(String name);

  /// Pops the current dependency scope
  /// 
  /// [name] - The name of the scope to pop
  Future<void> popScope(String name);

  /// Replaces the current dependency scope with a new one
  /// 
  /// [name] - The name of the new scope
  Future<void> replaceScope(String name);

  /// Checks if a scope with the given name exists
  /// 
  /// [name] - The name of the scope to check
  bool containsScope(String name);

  /// Adds a singleton dependency
  /// 
  /// [constructor] - Function that creates the dependency
  /// [dispose] - Optional function to clean up the dependency
  /// [name] - Optional name for the dependency
  void addSingleton<T extends Object>(
      DependencyBuilder<T> constructor, {
        DependencyDisposeFunc<T>? dispose,
        String? name,
      });

  /// Adds a lazy singleton dependency
  /// 
  /// The dependency is only created when first requested
  /// 
  /// [constructor] - Function that creates the dependency
  /// [dispose] - Optional function to clean up the dependency
  /// [name] - Optional name for the dependency
  void addLazySingleton<T extends Object>(
      DependencyBuilder<T> constructor, {
        DependencyDisposeFunc<T>? dispose,
        String? name,
      });

  /// Unregisters a dependency
  /// 
  /// [disposingFunction] - Optional function to clean up the dependency
  FutureOr unregister<T extends Object>({
    DependencyDisposeFunc? disposingFunction,
  });
}
