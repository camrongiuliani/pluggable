class MapperNotRegistered<FROM extends Object, TO extends Object>
    implements Exception {

  final bool async;

  MapperNotRegistered([this.async = false]);

  @override
  String toString() => '$FROM to ${async ? 'Future<$TO>' : '$TO'} is not mappable!';
}
