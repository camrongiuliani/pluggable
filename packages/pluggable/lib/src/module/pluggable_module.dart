/// Abstract base class for Pluggable modules.
/// 
/// A [PluggableModule] represents a self-contained unit of functionality
/// that can be plugged into the Pluggable system. It manages its own
/// dependencies, storage, analytics, logging, and data mapping.
/// 
/// Example usage:
/// ```dart
/// class MyModule extends PluggableModule {
///   @override
///   void addDependencies(PluggableDI i) {
///     // Register dependencies here
///   }
///   
///   @override
///   List<Mapper> registerMappers(PluggableMapper cartograph) {
///     // Register mappers here
///     return [];
///   }
/// }
/// ```

import 'dart:async';
import 'package:pluggable/pluggable.dart';
import 'package:uuid/uuid.dart';

abstract class PluggableModule extends Plug<PluggableModule> {
  /// Unique identifier for this module instance
  late final String _key;
  
  /// Unique identifier for dependency injection scope
  late final String _diKey;
  
  /// Optional custom storage implementation
  late final PluggableStorage? _storage;
  
  /// Optional custom dependency injection implementation
  late final PluggableDI? _di;
  
  /// Optional custom analytics implementation
  late final PluggableAnalytics? _analytics;
  
  /// Optional custom logger implementation
  late final PluggableLogger? _logger;
  
  /// Optional custom mapper implementation
  late final PluggableMapper? _mapper;

  /// Registers this module with the Pluggable system
  Future<void> plugin(PluggableImpl pluggable) async {
    return pluggable.plugin(this);
  }

  /// Flag indicating whether the module is bound to the system
  bool bound = false;

  /// Stream subscription for module events
  StreamSubscription? ss;

  /// Creates a new PluggableModule instance with optional custom implementations
  /// 
  /// [storagePlugin] - Optional custom storage implementation
  /// [diPlugin] - Optional custom dependency injection implementation
  /// [analyticsPlugin] - Optional custom analytics implementation
  /// [loggerPlugin] - Optional custom logger implementation
  /// [mapperPlugin] - Optional custom mapper implementation
  PluggableModule({
    PluggableStorage? storagePlugin,
    PluggableDI? diPlugin,
    PluggableAnalytics? analyticsPlugin,
    PluggableLogger? loggerPlugin,
    PluggableMapper? mapperPlugin,
  }) {
    _key = Uuid().v4();
    _diKey = '${runtimeType}_$_key';
    _storage = storagePlugin;
    _di = diPlugin;
    _analytics = analyticsPlugin;
    _logger = loggerPlugin;
    _mapper = mapperPlugin;
  }

  /// Gets the storage implementation, falling back to the system default if not provided
  PluggableStorage get storage => _storage ?? Pluggable.storage;

  /// Gets the dependency injection implementation, falling back to the system default if not provided
  PluggableDI get di => _di ?? Pluggable.di;

  /// Gets the analytics implementation, falling back to the system default if not provided
  PluggableAnalytics get analytics => _analytics ?? Pluggable.analytics;

  /// Gets the logger implementation, falling back to the system default if not provided
  PluggableLogger get logger => _logger ?? Pluggable.logger;

  /// Gets the mapper implementation, falling back to the system default if not provided
  PluggableMapper get mapper => _mapper ?? Pluggable.mapper;

  /// Override this method to register module-specific dependencies
  /// 
  /// [i] - The dependency injection container to register dependencies with
  void addDependencies(PluggableDI i) {}

  /// Override this method to register module-specific data mappers
  /// 
  /// [cartograph] - The mapper system to register mappers with
  /// Returns a list of mappers to be registered
  List<Mapper> registerMappers(PluggableMapper cartograph) => [];

  /// Binds the module to the system, registering dependencies and mappers
  /// 
  /// [log] - Whether to log the binding process
  void bind([bool log = true]) {
    if (bound) {
      return;
    }

    if (log) {
      Pluggable.logger.v('$runtimeType module bound', tag: '$runtimeType');
      Pluggable.di.pushScope(_diKey);
    }

    addDependencies(
      Pluggable.di,
    );

    _buildCartograph();

    bound = true;
  }

  /// Internal method to build and register the module's mappers
  void _buildCartograph() {
    Pluggable.mapper.buildAtlas(
      registerMappers(Pluggable.mapper),
    );

    logger.v(
      'Mappers Registered: ${Pluggable.mapper.mappers.length}',
      tag: '$runtimeType',
    );
  }

  /// Unbinds the module from the system, cleaning up resources
  void unbind() {
    if (!bound) {
      return;
    }

    Future.sync(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      Pluggable.logger.v('$runtimeType module unbound', tag: '$runtimeType');
      Pluggable.di.popScope(_diKey);

      bound = false;
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PluggableModule && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
