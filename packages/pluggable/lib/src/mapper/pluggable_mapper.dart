import 'package:pluggable/pluggable.dart';

export 'exceptions.dart';

abstract class PluggableMapper extends Plug<PluggableMapper> {
  List<Mapper> get mappers;

  @override
  Future<PluggableMapper> init() async {
    return this;
  }

  @override
  Future<PluggableMapper> dispose() async {
    mappers.clear();
    return this;
  }

  void buildAtlas<FROM extends Object, TO extends Object>(
    List<Mapper> creators,
  );

  bool isMapped<FROM extends Object, TO extends Object>();

  TO map<FROM extends Object, TO extends Object>(
    FROM source, [
    String? named,
  ]);

  TO? maybeMap<FROM extends Object, TO extends Object>(
    FROM source, [
    String? named,
  ]);
}

abstract class Mapper<FROM extends Object, TO extends Object> {
  const Mapper(
    this.mapper, [
    this.name,
  ]);

  final PluggableMapper mapper;

  final String? name;

  Type get from => FROM;

  Type get to => TO;

  bool isMapperFor<X extends Object, Y extends Object>(String? name) {
    return X == FROM && Y == TO && name == this.name;
  }

  TO map(FROM source);
}
