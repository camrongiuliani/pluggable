import 'package:flutter/widgets.dart';
import 'package:pluggable_flutter/src/navigator/custom_transition_page.dart';

class RouteTransitionPage extends CustomTransitionPage<void> {
  const RouteTransitionPage({
    required super.child,
    required super.transitionsBuilder,
    super.key,
    super.transitionDuration = const Duration(milliseconds: 250),
  });

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
