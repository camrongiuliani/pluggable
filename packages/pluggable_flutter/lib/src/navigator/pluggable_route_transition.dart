import 'package:flutter/widgets.dart';
import 'package:pluggable_flutter/src/navigator/custom_transition_page.dart';

/// A page that provides custom route transitions in the Pluggable framework.
///
/// This class extends [CustomTransitionPage] and provides various transition
/// effects for route navigation.
///
/// Example usage:
/// ```dart
/// RouteTransitionPage.slideLeft(
///   key: ValueKey('/home'),
///   child: HomePage(),
/// );
/// ```
class RouteTransitionPage extends CustomTransitionPage<void> {
  const RouteTransitionPage({
    required super.child,
    required super.transitionsBuilder,
    super.key,
    super.transitionDuration = const Duration(milliseconds: 250),
  });

  /// Creates a page with no transition effect.
  factory RouteTransitionPage.none({
    LocalKey? key,
    required Widget child,
  }) {
    return RouteTransitionPage(
      key: key,
      child: child,
      transitionDuration: Duration.zero,
      transitionsBuilder: (_, animation, __, child) {
        return child;
      },
    );
  }

  /// Creates a page with a fade transition effect.
  factory RouteTransitionPage.mobileSlideWebFade({
    LocalKey? key,
    required Widget child,
    required int next,
    required int current,
  }) {
    return RouteTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, __, child) {
        final Size size = MediaQuery.sizeOf(context);

        return switch (size.width <= 768) {
          true => switch (current < next) {
              true => _slideUp(animation, child),
              false => _slideDown(animation, child),
            },
          false => _fade(animation, child),
        };
      },
    );
  }

  /// Creates a page with a slide left transition effect.
  factory RouteTransitionPage.slideLeft({
    LocalKey? key,
    required Widget child,
  }) {
    return RouteTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (_, animation, __, child) {
        return _slideLeft(animation, child);
      },
    );
  }

  /// Creates a page with a slide up transition effect.
  factory RouteTransitionPage.slideUp({
    LocalKey? key,
    required Widget child,
  }) {
    return RouteTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (_, animation, __, child) {
        return _slideUp(animation, child);
      },
    );
  }

  /// Creates a page with a slide down transition effect.
  factory RouteTransitionPage.slideDown({
    LocalKey? key,
    required Widget child,
  }) {
    return RouteTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (_, animation, __, child) {
        return _slideDown(animation, child);
      },
    );
  }

  /// Creates a page with a fade transition effect.
  factory RouteTransitionPage.fade({
    LocalKey? key,
    required Widget child,
  }) {
    return RouteTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (_, animation, __, child) {
        return _fade(animation, child);
      },
    );
  }

  static Widget _slideLeft(
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static Widget _slideUp(
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static Widget _slideDown(
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        end: const Offset(0.0, 1.0),
        begin: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static Widget _fade(
    Animation<double> animation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      child: child,
    );
  }
}
