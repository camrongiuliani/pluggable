// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

/// A page that allows for custom transitions instead of the default Material or Cupertino transitions.
///
/// This class extends [Page] and provides a way to define custom transitions
/// for route navigation.
///
/// Example usage:
/// ```dart
/// CustomTransitionPage(
///   key: ValueKey('/home'),
///   child: HomePage(),
///   transitionsBuilder: (context, animation, secondaryAnimation, child) {
///     return FadeTransition(
///       opacity: animation,
///       child: child,
///     );
///   },
/// );
/// ```
class CustomTransitionPage<T> extends Page<T> {
  /// Creates a new [CustomTransitionPage].
  ///
  /// The [key] parameter is optional and provides a key for the page.
  /// The [child] parameter is required and specifies the widget to display.
  /// The [transitionsBuilder] parameter is required and defines how to build the transition.
  /// The [maintainState] parameter determines if the state should be maintained (defaults to true).
  /// The [fullscreenDialog] parameter determines if the page is a fullscreen dialog (defaults to false).
  /// The [opaque] parameter determines if the page is opaque (defaults to true).
  /// The [barrierDismissible] parameter determines if the barrier can be dismissed (defaults to false).
  /// The [barrierColor] parameter specifies the color of the barrier (defaults to null).
  /// The [barrierLabel] parameter specifies the label for the barrier (defaults to null).
  /// The [transitionDuration] parameter specifies the duration of the transition (defaults to 300ms).
  /// The [reverseTransitionDuration] parameter specifies the duration of the reverse transition (defaults to 300ms).
  const CustomTransitionPage({
    super.key,
    required this.child,
    required this.transitionsBuilder,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
  });

  /// The widget to display.
  final Widget child;

  /// The builder for the transition.
  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) transitionsBuilder;

  /// Whether to maintain the state of the route.
  final bool maintainState;

  /// Whether the route is a fullscreen dialog.
  final bool fullscreenDialog;

  /// Whether the route is opaque.
  final bool opaque;

  /// Whether the barrier can be dismissed.
  final bool barrierDismissible;

  /// The color of the barrier.
  final Color? barrierColor;

  /// The label for the barrier.
  final String? barrierLabel;

  /// The duration of the transition.
  final Duration transitionDuration;

  /// The duration of the reverse transition.
  final Duration reverseTransitionDuration;

  @override
  Route<T> createRoute(BuildContext context) {
    return _CustomTransitionRoute<T>(
      page: this,
      settings: this,
    );
  }
}

/// A page with no transition effect.
///
/// This class extends [CustomTransitionPage] and provides a way to create
/// a page without any transition effect.
///
/// Example usage:
/// ```dart
/// NoTransitionPage(
///   key: ValueKey('/home'),
///   child: HomePage(),
/// );
/// ```
class NoTransitionPage<T> extends CustomTransitionPage<T> {
  /// Creates a new [NoTransitionPage].
  ///
  /// The [key] parameter is optional and provides a key for the page.
  /// The [child] parameter is required and specifies the widget to display.
  /// The [maintainState] parameter determines if the state should be maintained (defaults to true).
  /// The [fullscreenDialog] parameter determines if the page is a fullscreen dialog (defaults to false).
  /// The [opaque] parameter determines if the page is opaque (defaults to true).
  /// The [barrierDismissible] parameter determines if the barrier can be dismissed (defaults to false).
  /// The [barrierColor] parameter specifies the color of the barrier (defaults to null).
  /// The [barrierLabel] parameter specifies the label for the barrier (defaults to null).
  NoTransitionPage({
    super.key,
    required super.child,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.opaque = true,
    super.barrierDismissible = false,
    super.barrierColor,
    super.barrierLabel,
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
}

class _CustomTransitionRoute<T> extends PageRoute<T> {
  _CustomTransitionRoute({
    required this.page,
    required super.settings,
  });

  final CustomTransitionPage<T> page;

  @override
  bool get maintainState => page.maintainState;

  @override
  bool get fullscreenDialog => page.fullscreenDialog;

  @override
  bool get opaque => page.opaque;

  @override
  bool get barrierDismissible => page.barrierDismissible;

  @override
  Color? get barrierColor => page.barrierColor;

  @override
  String? get barrierLabel => page.barrierLabel;

  @override
  Duration get transitionDuration => page.transitionDuration;

  @override
  Duration get reverseTransitionDuration => page.reverseTransitionDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return page.transitionsBuilder(
      context,
      animation,
      secondaryAnimation,
      page.child,
    );
  }
}
