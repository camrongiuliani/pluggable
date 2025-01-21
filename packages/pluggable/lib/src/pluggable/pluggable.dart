import 'dart:async';

import 'package:collection/collection.dart';
import 'package:event_bus/event_bus.dart';
import 'package:pluggable/pluggable.dart';
import 'package:pluggable_di_getit/pluggable_di_getit.dart';
import 'package:cartographer_mapper_plug/cartographer_mapper_plug.dart';
import 'package:in_memory_storage_plug/in_memory_storage_plug.dart';

// ignore: non_constant_identifier_names
PluggableImpl get Pluggable {
  if (PluggableImpl.instance == null || !PluggableImpl.instance!.initialized) {
    throw Exception('Pluggable not initialized');
  }

  return PluggableImpl.instance!;
}

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
    await pluggable.plugin(loggingPlugin ?? ConsoleLoggerPlug());
    await pluggable.plugin(mapperPlugin ?? CartographerMapperPlug());
    await pluggable.plugin(diPlugin ?? PluggableGetIt());
    await pluggable.plugin(storagePlugin ?? InMemoryStoragePlug());
    await pluggable.plugin(analyticsPlugin ?? NoAnalyticsPlug());

    await pluggable._init();

    for (final module in modules) {
      await pluggable.plugin(module);
    }
  }

  return pluggable;
}

class PluggableImpl extends DartNotifier {
  static PluggableImpl? instance;

  PluggableImpl._()
      : ucm = UseCaseManager(debug: true),
        _bus = EventBus();

  factory PluggableImpl() {
    return instance ??= PluggableImpl._();
  }

  final EventBus _bus;

  StreamSubscription? triggerStreamSubscription;

  final List<Plug> plugins = [];

  Iterable<PluggableModule> get modules {
    return plugins.whereType<PluggableModule>();
  }

  T get<T extends Plug<T>>() {
    return plugins.firstWhere((p) => p is T) as T;
  }

  T? maybeGet<T extends Plug<T>>() {
    return plugins.firstWhereOrNull((p) => p is T) as T?;
  }

  bool debug = false;

  PluggableDI get di => get();

  PluggableLogger get logger => switch (initialized) {
    true => get(),
    false => _initLogger,
  };

  PluggableLogger get _initLogger => maybeGet() ?? ConsoleLoggerPlug();

  PluggableStorage get storage => get();

  PluggableAnalytics get analytics => get();

  PluggableMapper get mapper => get();

  final UseCaseManager ucm;

  bool initialized = false;

  bool containsPlugin<T extends Plug<T>>() {
    var plugs = plugins.whereType<T>().toList();
    var contains = plugs.isNotEmpty;

    return contains;
  }

  Future<void> plugin<T extends Plug<T>>(
    covariant Plug<T> plug, {
    bool allowReassignment = false,
    bool notify = true,
  }) async {
    logger.v(
      'Trying to plug in ${plug.runtimeType}',
      tag: '$runtimeType',
    );

    if (containsPlugin<T>()) {
      if (allowReassignment) {
        await Future.wait(
          plugins.whereType<T>().map(
                (p) => p.dispose(),
              ),
        );
      } else {
        throw Exception('${plug.runtimeType} already plugged in');
      }
    }

    plugins.add(
      await plug.init(),
    );

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

  Future<void> _subscribeEventBus() async {
    if (triggerStreamSubscription != null) {
      await triggerStreamSubscription?.cancel();
      triggerStreamSubscription = null;
    }

    triggerStreamSubscription = on().listen((event) {
      // onEventTrigger(event);
    });
  }

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

  Future<void> emit(event) async {
    await Future.delayed(Duration.zero);
    _bus.fire(event);
    await Future.delayed(Duration.zero);
  }

  Stream<T> on<T>() => _bus.on<T>();
}

class DartNotifier {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  Stream<void> get stream => _controller.stream;

  void notifyListeners() {
    if (!_controller.isClosed) {
      _controller.add(null);
    }
  }

  void dispose() {
    _controller.close();
  }
}
