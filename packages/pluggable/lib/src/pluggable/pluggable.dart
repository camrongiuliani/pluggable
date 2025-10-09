/// Core implementation of the Pluggable framework.
///
/// This file contains the main implementation of the Pluggable system,
/// which provides a modular architecture for building extensible applications.
/// It manages plugins, handles initialization, and provides access to various
/// system components through a unified interface.

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:event_bus/event_bus.dart';
import 'package:pluggable/pluggable.dart';
import 'package:pluggable_di_getit/pluggable_di_getit.dart';
import 'package:cartographer_mapper_plug/cartographer_mapper_plug.dart';
import 'package:in_memory_storage_plug/in_memory_storage_plug.dart';

/// Global accessor for the Pluggable instance.
///
/// Returns the current instance of [PluggableImpl] if it exists and is initialized.
/// Throws an exception if Pluggable hasn't been initialized yet.
// ignore: non_constant_identifier_names
PluggableImpl get Pluggable {
  if (PluggableImpl.instance == null || !PluggableImpl.instance!.initialized) {
    throw Exception('Pluggable not initialized');
  }

  return PluggableImpl.instance!;
}

/// Initializes the Pluggable framework with optional modules and plugins.
///
/// This function sets up the core Pluggable system with default or provided plugins
/// for various functionalities like logging, storage, analytics, etc.
///
/// [modules] - List of modules to be initialized
/// [storagePlugin] - Optional custom storage plugin
/// [analyticsPlugin] - Optional custom analytics plugin
/// [loggingPlugin] - Optional custom logging plugin
/// [diPlugin] - Optional custom dependency injection plugin
/// [mapperPlugin] - Optional custom mapper plugin
Future<PluggableImpl> initPluggable({
  List<PluggableModule> modules = const [],
  PluggableStorage? storagePlugin,
  PluggableAnalytics? analyticsPlugin,
  PluggableLogger? loggingPlugin,
  PluggableDI? diPlugin,
  PluggableMapper? mapperPlugin,
}) async {
  final pluggable = PluggableImpl();

  if (!pluggable.initialized) {
    // Initialize core plugins with defaults if not provided
    await pluggable.plugin(loggingPlugin ?? ConsoleLoggerPlug());
    await pluggable.plugin(mapperPlugin ?? CartographerMapperPlug());
    await pluggable.plugin(diPlugin ?? PluggableGetIt());
    await pluggable.plugin(
      storagePlugin ??
          PluggableStorage(
            local: InMemoryStoragePlug(),
            remote: InMemoryStoragePlug(),
          ),
    );
    await pluggable.plugin(analyticsPlugin ?? NoAnalyticsPlug());

    await pluggable._init();

    // Initialize provided modules
    for (final module in modules) {
      pluggable.logger.v(
        'Trying to plug in ${module.runtimeType}',
        tag: 'PluggableInit',
      );

      pluggable.plugins.add(
        await module.init(),
      );

      pluggable.logger.v(
        'Plugged in ${module.runtimeType}',
        tag: 'PluggableInit',
      );
    }
  }

  return pluggable;
}

/// The main implementation class of the Pluggable framework.
///
/// This class manages the lifecycle of plugins, provides access to system components,
/// and handles event communication between different parts of the system.
class PluggableImpl extends DartNotifier {
  /// Singleton instance of PluggableImpl
  static PluggableImpl? instance;

  /// Private constructor for singleton pattern
  PluggableImpl._()
      : ucm = UseCaseManager(debug: true),
        _bus = EventBus();

  /// Factory constructor that ensures only one instance exists
  factory PluggableImpl() {
    return instance ??= PluggableImpl._();
  }

  /// Event bus for handling system-wide events
  final EventBus _bus;

  /// Subscription for trigger events
  StreamSubscription? triggerStreamSubscription;

  /// List of all active plugins
  final List<Plug> plugins = List.empty(growable: true);

  /// Getter for all registered modules
  Iterable<PluggableModule> get modules {
    return plugins.whereType<PluggableModule>();
  }

  /// Retrieves a plugin of the specified type
  ///
  /// Throws an exception if the plugin is not found
  T get<T extends Plug<T>>() {
    return plugins.firstWhere((p) => p is T) as T;
  }

  /// Safely retrieves a plugin of the specified type
  ///
  /// Returns null if the plugin is not found
  T? maybeGet<T extends Plug<T>>() {
    try {
      return plugins.firstWhereOrNull((p) => p is T) as T?;
    } catch (_) {
      return null;
    }
  }

  /// Debug mode flag
  bool debug = false;

  /// Accessor for dependency injection
  PluggableDI get di => get();

  /// Accessor for logger, falls back to console logger if not initialized
  PluggableLogger get logger => switch (initialized) {
        true => maybeGet() ?? ConsoleLoggerPlug(),
        false => _initLogger,
      };

  /// Fallback logger used during initialization
  PluggableLogger get _initLogger => maybeGet() ?? ConsoleLoggerPlug();

  /// Accessor for storage system
  PluggableStorage get storage => get();

  /// Accessor for analytics system
  PluggableAnalytics get analytics => get();

  /// Accessor for mapper system
  PluggableMapper get mapper => get();

  /// Use case manager for handling business logic
  final UseCaseManager ucm;

  /// Initialization status flag
  bool initialized = false;

  /// Checks if a plugin of the specified type exists
  bool containsPlugin<T extends Plug<T>>() {
    return plugins.any((p) => p.sameType<T>());
  }

  /// Adds a new plugin to the system
  ///
  /// [plug] - The plugin to add
  /// [allowReassignment] - Whether to allow replacing existing plugins
  /// [notify] - Whether to notify listeners of the change
  Future<void> plugin<T extends Plug<T>>(
    covariant Plug<T> plug, {
    bool allowReassignment = false,
    bool notify = true,
    bool init = true,
  }) async {
    logger.v(
      'Trying to plug in ${plug.runtimeType}',
      tag: '$runtimeType',
    );

    if (containsPlugin<T>()) {
      logger.v(
        '${plug.runtimeType} already plugged in, allow reassignment: $allowReassignment',
        tag: '$runtimeType',
      );

      if (allowReassignment) {
        await Future.wait(
          plugins.whereType<T>().map(
                (p) => p.dispose(),
              ),
        );

        plugins.removeWhere((p) => p is T);
      } else {
        throw Exception('${plug.runtimeType} already plugged in');
      }
    } else if (allowReassignment) {
      logger.v(
        'Warning: allowReassignment is true but no existing plugin of type ${plug.runtimeType} found.',
        tag: '$runtimeType',
      );
    }

    if (init) {
      await plug.init();
    }

    plugins.add(plug);

    if (containsPlugin<T>()) {
      logger.v(
        'Plugged in ${plug.runtimeType}',
        tag: '$runtimeType',
      );
    } else {
      throw Exception('Failed to plug in ${plug.runtimeType}');
    }

    if (notify) {
      notifyListeners();
    }
  }

  /// Sets up event bus subscription
  Future<void> _subscribeEventBus() async {
    if (triggerStreamSubscription != null) {
      await triggerStreamSubscription?.cancel();
      triggerStreamSubscription = null;
    }

    triggerStreamSubscription = on().listen((event) {
      // onEventTrigger(event);
    });
  }

  /// Initializes the Pluggable system
  Future<PluggableImpl> _init() async {
    if (initialized) {
      logger.i(
        'WARNING: Pluggable already initialized.',
        tag: '$runtimeType',
      );

      await dispose();
    }

    _subscribeEventBus();

    initialized = true;

    return this;
  }

  /// Disposes of all plugins and cleans up resources
  @override
  Future<void> dispose() async {
    await Future.wait(
      plugins.map(
        (p) => p.dispose(),
      ),
    );

    await triggerStreamSubscription?.cancel();
    triggerStreamSubscription = null;

    instance = null;

    super.dispose();
  }

  /// Emits an event through the event bus
  Future<void> emit(event) async {
    await Future.delayed(Duration.zero);
    _bus.fire(event);
    await Future.delayed(Duration.zero);
  }

  /// Subscribes to events of a specific type
  Stream<T> on<T>() => _bus.on<T>();
}

/// A simple notifier class for implementing the observer pattern
class DartNotifier {
  /// Controller for managing notification streams
  final StreamController<void> _controller = StreamController<void>.broadcast();

  /// Stream of notifications
  Stream<void> get stream => _controller.stream;

  /// Notifies all listeners
  void notifyListeners() {
    if (!_controller.isClosed) {
      _controller.add(null);
    }
  }

  /// Cleans up resources
  void dispose() {
    _controller.close();
  }
}
