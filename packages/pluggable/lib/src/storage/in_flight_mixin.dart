import 'dart:async';
import 'dart:collection';

typedef InFlightSets = Map<Type, LinkedHashMap<String, InFlightEntry<Object?>>>;

mixin InFlightMixin {
  final InFlightSets _inFlightSets = {};

  void markAsInFlight<T extends Object>(String key) async {
    if (!isKeyInFlight(key)) {
      _inFlightSets[T] ??= LinkedHashMap<String, InFlightEntry<Object?>>();
      _inFlightSets[T]?[key] = InFlightEntry<T>(Completer(), DateTime.now());
    }
  }

  void removeInFlight<T extends Object>(String key) {
    _inFlightSets[T]?.remove(key);
  }

  bool isKeyInFlight<T extends Object>(String key) {
    return _inFlightSets.containsKey(T) && _inFlightSets[T]!.containsKey(key);
  }

  void resolveInFlightRequest<T extends Object>(String key, T? value) {
    final completer = _inFlightSets[T]?[key]?.completer;

    if (completer == null) {
      return;
    }

    completer.complete(value);

    removeInFlight<T>(key);
  }

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

class InFlightEntry<V> {
  final Completer<V?> _completer;
  final DateTime _createTime;

  InFlightEntry(this._completer, this._createTime);

  DateTime get createTime => _createTime;

  Completer<V?> get completer => _completer;
}