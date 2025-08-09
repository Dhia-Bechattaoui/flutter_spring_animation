import 'package:flutter/widgets.dart';

import 'spring_config.dart';
import 'spring_controller.dart';

/// A widget that builds its child based on the current value of a spring animation.
///
/// This widget provides a declarative way to create spring animations
/// without manually managing controllers.
class SpringAnimationBuilder extends StatefulWidget {
  /// Creates a spring animation builder.
  ///
  /// [config] defines the spring parameters
  /// [target] is the target value to animate to
  /// [builder] is called with the current animation value
  /// [duration] is an optional parameter for controlling animation timing
  const SpringAnimationBuilder({
    required this.config,
    required this.target,
    required this.builder,
    this.initialValue = 0.0,
    this.duration,
    super.key,
  });

  /// The spring configuration.
  final SpringConfig config;

  /// The target value to animate to.
  final double target;

  /// The initial value of the animation.
  final double initialValue;

  /// Optional duration parameter (mainly for compatibility).
  final Duration? duration;

  /// Builder function that creates the widget tree.
  ///
  /// Called with the current animation value (0.0 to 1.0).
  final Widget Function(BuildContext context, double value) builder;

  @override
  State<SpringAnimationBuilder> createState() => _SpringAnimationBuilderState();
}

class _SpringAnimationBuilderState extends State<SpringAnimationBuilder> {
  late SpringController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SpringController(
      config: widget.config,
      initialValue: widget.initialValue,
    );

    // Start animation to target
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(widget.target);
    });
  }

  @override
  void didUpdateWidget(SpringAnimationBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update target if it changed
    if (widget.target != oldWidget.target) {
      _controller.animateTo(widget.target);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return widget.builder(context, _controller.value);
      },
    );
  }
}

/// A widget that automatically manages spring animations for common use cases.
class SpringTransition extends StatelessWidget {
  /// Creates a spring transition widget.
  ///
  /// [child] is the widget to animate
  /// [visible] controls whether the widget is visible (animates opacity)
  /// [config] defines the spring parameters
  const SpringTransition({
    required this.child,
    required this.visible,
    this.config = const SpringConfig(),
    super.key,
  });

  /// The child widget to animate.
  final Widget child;

  /// Whether the widget should be visible.
  final bool visible;

  /// The spring configuration.
  final SpringConfig config;

  @override
  Widget build(BuildContext context) {
    return SpringAnimationBuilder(
      config: config,
      target: visible ? 1.0 : 0.0,
      builder: (context, value) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: child,
          ),
        );
      },
    );
  }
}

/// A widget that creates a spring-based slide transition.
class SpringSlideTransition extends StatelessWidget {
  /// Creates a spring slide transition.
  ///
  /// [child] is the widget to animate
  /// [visible] controls whether the widget is visible
  /// [direction] controls the slide direction
  /// [config] defines the spring parameters
  const SpringSlideTransition({
    required this.child,
    required this.visible,
    this.direction = AxisDirection.up,
    this.config = const SpringConfig(),
    super.key,
  });

  /// The child widget to animate.
  final Widget child;

  /// Whether the widget should be visible.
  final bool visible;

  /// The direction to slide from/to.
  final AxisDirection direction;

  /// The spring configuration.
  final SpringConfig config;

  @override
  Widget build(BuildContext context) {
    return SpringAnimationBuilder(
      config: config,
      target: visible ? 1.0 : 0.0,
      builder: (context, value) {
        final offset = _getOffset(value);
        return Transform.translate(
          offset: offset,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
    );
  }

  Offset _getOffset(double value) {
    final progress = 1.0 - value;
    const distance = 50.0;

    switch (direction) {
      case AxisDirection.up:
        return Offset(0, distance * progress);
      case AxisDirection.down:
        return Offset(0, -distance * progress);
      case AxisDirection.left:
        return Offset(distance * progress, 0);
      case AxisDirection.right:
        return Offset(-distance * progress, 0);
    }
  }
}

/// A widget that creates a spring-based rotation transition.
class SpringRotationTransition extends StatelessWidget {
  /// Creates a spring rotation transition.
  ///
  /// [child] is the widget to animate
  /// [visible] controls whether the widget is visible
  /// [turns] is the number of turns to rotate (default is 0.25 for 90 degrees)
  /// [config] defines the spring parameters
  const SpringRotationTransition({
    required this.child,
    required this.visible,
    this.turns = 0.25,
    this.config = const SpringConfig(),
    super.key,
  });

  /// The child widget to animate.
  final Widget child;

  /// Whether the widget should be visible.
  final bool visible;

  /// The number of turns to rotate.
  final double turns;

  /// The spring configuration.
  final SpringConfig config;

  @override
  Widget build(BuildContext context) {
    return SpringAnimationBuilder(
      config: config,
      target: visible ? 1.0 : 0.0,
      builder: (context, value) {
        return Transform.rotate(
          angle: turns * 2 * 3.14159 * (1.0 - value),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
    );
  }
}

/// A widget that creates a spring-based size transition.
class SpringSizeTransition extends StatelessWidget {
  /// Creates a spring size transition.
  ///
  /// [child] is the widget to animate
  /// [visible] controls whether the widget is visible
  /// [axis] controls which axis to animate (both by default)
  /// [config] defines the spring parameters
  const SpringSizeTransition({
    required this.child,
    required this.visible,
    this.axis,
    this.config = const SpringConfig(),
    super.key,
  });

  /// The child widget to animate.
  final Widget child;

  /// Whether the widget should be visible.
  final bool visible;

  /// The axis to animate. If null, both axes are animated.
  final Axis? axis;

  /// The spring configuration.
  final SpringConfig config;

  @override
  Widget build(BuildContext context) {
    return SpringAnimationBuilder(
      config: config,
      target: visible ? 1.0 : 0.0,
      builder: (context, value) {
        final scaleX = axis == Axis.vertical ? 1.0 : value;
        final scaleY = axis == Axis.horizontal ? 1.0 : value;

        return Transform.scale(
          scaleX: scaleX,
          scaleY: scaleY,
          child: child,
        );
      },
    );
  }
}
