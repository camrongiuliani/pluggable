/// Exception thrown when a mapper is not registered for a specific type conversion.
/// 
/// This exception is thrown when attempting to map between two types for which
/// no mapper has been registered. It supports both synchronous and asynchronous
/// mapping scenarios.
/// 
/// Example usage:
/// ```dart
/// try {
///   final result = mapper.map<SourceType, TargetType>(source);
/// } on MapperNotRegistered catch (e) {
///   // Handle missing mapper
/// }
/// ```

class MapperNotRegistered<FROM extends Object, TO extends Object>
    implements Exception {

  /// Flag indicating whether this is an async mapping attempt
  final bool async;

  /// Creates a new MapperNotRegistered exception
  /// 
  /// [async] - Whether this is an async mapping attempt
  MapperNotRegistered([this.async = false]);

  @override
  String toString() => '$FROM to ${async ? 'Future<$TO>' : '$TO'} is not mappable!';
}
