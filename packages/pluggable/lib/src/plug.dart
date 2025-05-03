/// Abstract base class for all pluggable components in the system.
/// 
/// A [Plug] represents a modular component that can be initialized and disposed.
/// It uses a generic type parameter [T] to ensure type safety and enable type checking
/// between different plug implementations.
/// 
/// Example usage:
/// ```dart
/// class MyPlug extends Plug<MyPlug> {
///   @override
///   Future<Plug> init() async {
///     // Initialize your plug here
///     return this;
///   }
/// }
/// ```
abstract class Plug<T extends Plug<T>> {
  /// Initializes the plug.
  /// 
  /// This method should be overridden to perform any necessary setup
  /// when the plug is first loaded. The default implementation returns
  /// the plug instance itself.
  Future<Plug> init() async => this;

  /// Disposes of the plug.
  /// 
  /// This method should be overridden to perform any necessary cleanup
  /// when the plug is being removed. The default implementation returns
  /// the plug instance itself.
  Future<Plug> dispose() async => this;

  /// Checks if this plug is of the same type as another plug.
  /// 
  /// This method uses the generic type parameter to determine if two plugs
  /// are of the same type. It's useful for type checking and ensuring
  /// type safety when working with different plug implementations.
  bool sameType<X extends Plug<X>>() => T == X;
}
