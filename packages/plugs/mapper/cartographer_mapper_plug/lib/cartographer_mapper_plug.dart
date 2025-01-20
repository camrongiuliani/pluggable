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
    _mappers.addAll(creators);
  }

  @override
  bool isMapped<FROM extends Object, TO extends Object>([
    String? named,
  ]) {
    return _maybeGetMapper<FROM, TO>(named) != null;
  }

  Mapper? _maybeGetMapper<FROM extends Object, TO extends Object>([
    String? named,
  ]) {
    return _mappers.firstWhereOrNull((m) {
      return m.isMapperFor<FROM, TO>(named);
    });
  }

  Mapper _getMapper<FROM extends Object, TO extends Object>([
    String? named,
  ]) {
    final mapper = _maybeGetMapper<FROM, TO>(named);

    if (mapper == null) {
      throw MapperNotRegistered<FROM, TO>();
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
}
