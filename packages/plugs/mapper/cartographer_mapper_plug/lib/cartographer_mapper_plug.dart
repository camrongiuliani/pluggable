import 'package:pluggable/pluggable.dart';
import 'package:collection/collection.dart';

class CartographerMapperPlug extends PluggableMapper {
  final List<Mapper> _mappers = [];

  @override
  List<Mapper> get mappers => List.from(
        _mappers,
      );

  @override
  void buildAtlas<FROM extends Object, TO extends Object>(
    List<Mapper> creators,
  ) {
    _mappers.addAll(
        // (for final m in creators)
        creators.map((m) {
          Pluggable.logger.i('Registered mapper of type ${m.from} to ${m.to}');
          return m;
        })
    );
  }

  @override
  bool isMapped<FROM extends Object, TO extends Object>([
    String? named,
  ]) {
    return _maybeGetMapper<FROM, TO>(named) != null;
  }

  Mapper? _maybeGetMapper<FROM extends Object, TO extends Object>([
    String? named,
    bool async = false,
  ]) {
    return _mappers.where((m) {
      return (async && m is AsyncMapper) || (!async && m is! AsyncMapper);
    }).firstWhereOrNull((m) {
      return m.isMapperFor<FROM, TO>(named);
    });
  }

  Mapper _getMapper<FROM extends Object, TO extends Object>([
    String? named,
    bool async = false,
  ]) {
    final mapper = _maybeGetMapper<FROM, TO>(named, async);

    if (mapper == null) {
      throw MapperNotRegistered<FROM, TO>(async);
    }

    return mapper;
  }

  @override
  TO? maybeMap<FROM extends Object, TO extends Object>(
    FROM source, [
    String? named,
  ]) {
    return _maybeGetMapper<FROM, TO>(named)?.map(source) as TO;
  }

  @override
  TO map<FROM extends Object, TO extends Object>(
    FROM source, [
    String? named,
  ]) {
    return _getMapper<FROM, TO>(named).map(source) as TO;
  }

  @override
  Future<TO> mapAsync<FROM extends Object, TO extends Object>(
    FROM source, [
    String? named,
  ]) {
    final mapper = _getMapper<FROM, TO>(named, true);

    if (mapper is! AsyncMapper) {
      throw MapperNotRegistered<FROM, TO>(true);
    }

    return mapper.mapAsync(source) as Future<TO>;
  }

  @override
  Future<TO?> maybeMapAsync<FROM extends Object, TO extends Object>(
    FROM source, [
    String? named,
  ]) async {
    final mapper = _getMapper<FROM, TO>(named, true);

    if (mapper is! AsyncMapper) {
      return null;
    }

    return mapper.mapAsync(source) as Future<TO>;
  }
}
