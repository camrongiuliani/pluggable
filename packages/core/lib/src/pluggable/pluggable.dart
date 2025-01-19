import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pluggable/pluggable.dart';
import 'package:pluggable/src/analytics/pluggable_analytics.dart';
import 'package:pluggable/src/di/pluggable_di.dart';
import 'package:pluggable/src/logger/pluggable_logger.dart';
import 'package:pluggable/src/plug.dart';
import 'package:pluggable/src/storage/pluggable_storage.dart';
import 'package:pluggable_di_getit/pluggable_di_getit.dart';
import 'package:use_case/use_case.dart';

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
}) async {
  final pluggable = PluggableImpl();

  if (!pluggable.initialized) {
    await pluggable.plugin(storagePlugin ?? MemoryStoragePlug());
    await pluggable.plugin(analyticsPlugin ?? NoAnalyticsPlug());
    await pluggable.plugin(loggingPlugin ?? ConsoleLoggerPlug());
    await pluggable.plugin(diPlugin ?? PluggableGetIt());

    await pluggable._init();

    for (final module in modules) {
      await pluggable.plugin(module);
    }
  }

  return pluggable;
}

class PluggableImpl extends ChangeNotifier {
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

  bool debug = false;

  PluggableDI get di => get();

  PluggableLogger get logger => get();

  PluggableStorage get storage => get();

  PluggableAnalytics get analytics => get();

  final UseCaseManager ucm;

  // final IdentityProvider idp;

  bool initialized = false;

  bool containsPlugin<T extends Plug<T>>() {
    var type = T;
    var plugs = plugins.where((p) => p is T).toList();
    var contains = plugs.isNotEmpty;

    if (contains) {
      print('object');
    } else {
      print('object');
    }

    return contains;
  }

  Future<void> plugin<T extends Plug<T>>(
    covariant Plug<T> plug, {
    bool allowReassignment = false,
    bool notify = true,
  }) async {
    print('Trying to plug in ${plug.runtimeType}');

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
      print('Plugged in ${plug.runtimeType}');
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
      log(
        'WARNING: Pluggable already initialized.',
        tag: '$runtimeType',
      );
      return this;
    }

    _subscribeEventBus();

    initialized = true;

    return this;
  }

  Future<void> emit(event) async {
    await Future.delayed(Duration.zero);
    _bus.fire(event);
    await Future.delayed(Duration.zero);
  }

  Stream<T> on<T>() => _bus.on<T>();

  // bool get analyticsEnabled => initialized && analytics.enabled;

  void log(String message, {String? tag, Object? err, StackTrace? stackTrace}) {
    logger.log(message, tag: tag, err: err, stackTrace: stackTrace);
  }
}
