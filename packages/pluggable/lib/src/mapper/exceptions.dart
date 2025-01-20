class MapperNotRegistered<FROM extends Object, TO extends Object>
    implements Exception {
  @override
  String toString() => '$FROM to $TO is not mappable!';
}
