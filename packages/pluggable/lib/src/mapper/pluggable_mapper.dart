/// Core mapper implementation for the Pluggable system.
/// 
/// This class provides functionality for mapping objects between different types,
/// supporting both synchronous and asynchronous mapping operations. It maintains
/// a registry of mappers and handles the mapping process.
/// 
/// Example usage:
/// ```dart
/// class MyMapper extends PluggableMapper {
///   @override
///   void buildAtlas(List<Mapper> creators) {
///     // Register mappers
///   }
///   
///   @override
///   TO map<FROM extends Object, TO extends Object>(FROM source, [String? named]) {
///     // Implementation
///   }
/// }
/// ```

import 'package:pluggable/pluggable.dart';

export 'exceptions.dart';

abstract class PluggableMapper extends Plug<PluggableMapper> {
  /// List of registered mappers
  List<Mapper> get mappers;

  /// Initializes the mapper
  @override
  Future<PluggableMapper> init() async {
    return this;
  }

  /// Disposes of the mapper, clearing all registered mappers
  @override
  Future<PluggableMapper> dispose() async {
    mappers.clear();
    return this;
  }

  /// Builds the mapper atlas with the provided creators
  /// 
  /// [creators] - List of mapper creators to register
  void buildAtlas<FROM extends Object, TO extends Object>(
    List<Mapper> creators,
  );

  /// Checks if a mapping exists between two types
  /// 
  /// Returns true if a mapper exists for the specified types
  bool isMapped<FROM extends Object, TO extends Object>();

  /// Maps an object from one type to another
  /// 
  /// [source] - The source object to map
  /// [named] - Optional name for the mapper to use
  /// 
  /// Throws an exception if no mapper is found
  TO map<FROM extends Object, TO extends Object>(
    FROM source, [
    String? named,
  ]);

  /// Safely maps an object from one type to another
  /// 
  /// [source] - The source object to map
  /// [named] - Optional name for the mapper to use
  /// 
  /// Returns null if no mapper is found
  TO? maybeMap<FROM extends Object, TO extends Object>(
    FROM source, [
    String? named,
  ]);

  /// Asynchronously maps an object from one type to another
  /// 
  /// [source] - The source object to map
  /// [named] - Optional name for the mapper to use
  /// 
  /// Throws an exception if no mapper is found
  Future<TO> mapAsync<FROM extends Object, TO extends Object>(
    FROM source, [
    String? named,
  ]);

  /// Safely asynchronously maps an object from one type to another
  /// 
  /// [source] - The source object to map
  /// [named] - Optional name for the mapper to use
  /// 
  /// Returns null if no mapper is found
  Future<TO?> maybeMapAsync<FROM extends Object, TO extends Object>(
    FROM source, [
    String? named,
  ]);
}

/// Base class for synchronous mappers
abstract class Mapper<FROM extends Object, TO extends Object> {
  /// Creates a new mapper
  /// 
  /// [mapper] - The parent mapper instance
  /// [name] - Optional name for the mapper
  const Mapper(
    this.mapper, [
    this.name,
  ]);

  /// The parent mapper instance
  final PluggableMapper mapper;

  /// The optional name of the mapper
  final String? name;

  /// Gets the source type
  Type get from => FROM;

  /// Gets the target type
  Type get to => TO;

  /// Checks if this mapper can handle a specific mapping
  /// 
  /// [name] - Optional name to check
  /// Returns true if this mapper can handle the specified types and name
  bool isMapperFor<X extends Object, Y extends Object>(String? name) {
    return X == FROM && Y == TO && name == this.name;
  }

  /// Maps a source object to the target type
  /// 
  /// [source] - The source object to map
  TO map(FROM source);
}

/// Base class for asynchronous mappers
abstract class AsyncMapper<FROM extends Object, TO extends Object>
    extends Mapper<FROM, TO> {
  /// Creates a new asynchronous mapper
  /// 
  /// [mapper] - The parent mapper instance
  /// [name] - Optional name for the mapper
  const AsyncMapper(
    super.mapper, [
    super.name,
  ]);

  /// Throws an exception if called, as this is an async mapper
  @override
  TO map(FROM source) {
    throw Exception('Called map() on an AsyncMapper');
  }

  /// Asynchronously maps a source object to the target type
  /// 
  /// [source] - The source object to map
  Future<TO> mapAsync(FROM source);
}
