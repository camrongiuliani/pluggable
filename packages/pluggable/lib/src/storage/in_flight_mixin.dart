/// Mixin for tracking in-flight requests in the storage system.
/// 
/// This mixin provides functionality to track and manage concurrent requests
/// for the same data, preventing duplicate operations and ensuring consistency.
/// 
/// Example usage:
/// ```dart
/// class MyStorageProvider extends PluggableStorageProvider with InFlightMixin {
///   @override
///   Future<T?> get<T extends Object>(String key) async {
///     if (isKeyInFlight<T>(key)) {
///       return inFlightRequest<T>(key);
///     }
///     
///     markAsInFlight<T>(key);
///     // Perform the actual request
///     resolveInFlightRequest<T>(key, result);
///   }
/// }
/// ```

import 'dart:async';
import 'dart:collection';

/// Type definition for tracking in-flight requests by type and key
typedef InFlightSets = Map<Type, LinkedHashMap<String, InFlightEntry<Object?>>>;

mixin InFlightMixin {
  /// Map of in-flight requests, organized by type and key
  final InFlightSets _inFlightSets = {};

  /// Marks a request as in-flight
  /// 
  /// [key] - The key of the request
  void markAsInFlight<T extends Object>(String key) async {
    if (!isKeyInFlight(key)) {
      _inFlightSets[T] ??= LinkedHashMap<String, InFlightEntry<Object?>>();
      _inFlightSets[T]?[key] = InFlightEntry<T>(Completer(), DateTime.now());
    }
  }

  /// Removes an in-flight request
  /// 
  /// [key] - The key of the request to remove
  void removeInFlight<T extends Object>(String key) {
    _inFlightSets[T]?.remove(key);
  }

  /// Checks if a request is in-flight
  /// 
  /// [key] - The key to check
  /// Returns true if the request is in-flight
  bool isKeyInFlight<T extends Object>(String key) {
    return _inFlightSets.containsKey(T) && _inFlightSets[T]!.containsKey(key);
  }

  /// Resolves an in-flight request with a value
  /// 
  /// [key] - The key of the request
  /// [value] - The value to resolve with
  void resolveInFlightRequest<T extends Object>(String key, T? value) {
    final completer = _inFlightSets[T]?[key]?.completer;

    if (completer == null) {
      return;
    }

    completer.complete(value);

    removeInFlight<T>(key);
  }

  /// Gets the result of an in-flight request
  /// 
  /// [key] - The key of the request
  /// Returns a future that completes with the request result
  Future<T?> inFlightRequest<T extends Object>(String key) async {
    final future = _inFlightSets[T]?[key]?.completer.future;

    if (future == null) {
      return null;
    }

    return (future as Future<T?>).then((value) {
      _inFlightSets[T]?.remove(key);
      return value;
    });
  }
}

/// Represents an in-flight request entry
class InFlightEntry<V> {
  /// Completer for the request
  final Completer<V?> _completer;
  
  /// Time when the request was created
  final DateTime _createTime;

  /// Creates a new in-flight entry
  InFlightEntry(this._completer, this._createTime);

  /// Gets the creation time of the request
  DateTime get createTime => _createTime;

  /// Gets the completer for the request
  Completer<V?> get completer => _completer;
}