import 'dart:async';
import 'package:pluggable/pluggable.dart';
import 'package:uuid/uuid.dart';

abstract class PluggableModule extends Plug<PluggableModule> {
  late final String _key;
  late final String _diKey;
  late final PluggableStorage? _storage;
  late final PluggableDI? _di;
  late final PluggableAnalytics? _analytics;
  late final PluggableLogger? _logger;
  late final PluggableMapper? _mapper;

  Future<void> plugin(PluggableImpl pluggable) async {
    return pluggable.plugin(this);
  }

  bool bound = false;

  StreamSubscription? ss;

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

  PluggableStorage get storage => _storage ?? Pluggable.storage;

  PluggableDI get di => _di ?? Pluggable.di;

  PluggableAnalytics get analytics => _analytics ?? Pluggable.analytics;

  PluggableLogger get logger => _logger ?? Pluggable.logger;

  PluggableMapper get mapper => _mapper ?? Pluggable.mapper;

  void addDependencies(PluggableDI i) {}

  List<Mapper> registerMappers(PluggableMapper cartograph) => [];

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

  void _buildCartograph() {
    Pluggable.mapper.buildAtlas(
      registerMappers(Pluggable.mapper),
    );

    logger.v(
      'Mappers Registered: ${Pluggable.mapper.mappers.length}',
      tag: '$runtimeType',
    );
  }

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
