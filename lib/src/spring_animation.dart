import 'dart:math' as math;

import 'package:flutter/scheduler.dart';

import 'spring_config.dart';

/// A spring-based animation that provides natural physics-based motion.
///
/// This class implements a spring animation using configurable damping,
/// stiffness, and mass parameters. The animation automatically handles
/// the physics calculations and provides smooth, natural motion.
class SpringAnimation {
  /// Creates a spring animation with the given configuration.
  ///
  /// [config] defines the spring parameters (damping, stiffness, etc.)
  /// [from] is the starting value of the animation
  /// [to] is the target value of the animation
  SpringAnimation({
    required this.config,
    required this.from,
    required this.to,
  })  : _currentValue = from,
        _currentVelocity = config.velocity;

  /// The spring configuration defining physics parameters.
  final SpringConfig config;

  /// The starting value of the animation.
  final double from;

  /// The target value of the animation.
  final double to;

  double _currentValue;
  double _currentVelocity;
  DateTime? _lastTime;
  bool _isRunning = false;

  // Test-only getters and setters for private fields
  set currentValue(double value) => _currentValue = value;

  set currentVelocity(double velocity) => _currentVelocity = velocity;

  set isRunningTest(bool running) => _isRunning = running;

  /// The current value of the animation.
  double get value => _currentValue;

  /// The current velocity of the animation.
  double get velocity => _currentVelocity;

  /// Whether the animation is currently running.
  bool get isRunning => _isRunning;

  /// Whether the animation has completed.
  bool get isCompleted =>
      !_isRunning && (_currentValue - to).abs() < config.tolerance;

  /// Starts the animation.
  ///
  /// [onUpdate] is called on each frame with the current value.
  /// [onComplete] is called when the animation completes.
  void start({
    required void Function(double value) onUpdate,
    void Function()? onComplete,
  }) {
    if (_isRunning) {
      return;
    }

    _isRunning = true;
    _lastTime = DateTime.now();

    void tick() {
      if (!_isRunning) {
        return;
      }

      final now = DateTime.now();
      final deltaTime = _lastTime != null
          ? (now.millisecondsSinceEpoch - _lastTime!.millisecondsSinceEpoch) /
              1000.0
          : 0.0;
      _lastTime = now;

      if (deltaTime > 0) {
        _updateSpringPhysics(deltaTime);
        onUpdate(_currentValue);

        // Check if animation should complete
        if (_shouldComplete()) {
          _currentValue = to;
          _currentVelocity = 0.0;
          _isRunning = false;
          onUpdate(_currentValue);
          onComplete?.call();
          return;
        }
      }

      SchedulerBinding.instance.scheduleFrameCallback((_) => tick());
    }

    SchedulerBinding.instance.scheduleFrameCallback((_) => tick());
  }

  /// Stops the animation.
  void stop() {
    _isRunning = false;
  }

  /// Resets the animation to its initial state.
  void reset() {
    _isRunning = false;
    _currentValue = from;
    _currentVelocity = config.velocity;
    _lastTime = null;
  }

  /// Updates the spring physics for the given time step.
  void _updateSpringPhysics(double deltaTime) {
    const maxDeltaTime = 1.0 / 60.0; // Cap at 60 FPS
    final clampedDeltaTime = math.min(deltaTime, maxDeltaTime);

    final displacement = _currentValue - to;
    final springForce = -config.stiffness * displacement;
    final dampingForce = -config.damping * _currentVelocity;
    final acceleration = (springForce + dampingForce) / config.mass;

    // Use improved Euler integration for better stability
    _currentVelocity += acceleration * clampedDeltaTime;
    _currentValue += _currentVelocity * clampedDeltaTime;
  }

  /// Determines if the animation should complete based on tolerance.
  bool _shouldComplete() {
    final displacement = (_currentValue - to).abs();
    final velocity = _currentVelocity.abs();

    return displacement < config.tolerance && velocity < config.tolerance;
  }

  /// Test-only method to access _shouldComplete
  bool shouldCompleteTest() => _shouldComplete();

  /// Test-only method to access _updateSpringPhysics
  void updateSpringPhysicsTest(double deltaTime) =>
      _updateSpringPhysics(deltaTime);

  /// Updates the target value of the animation.
  ///
  /// This allows for smooth transitions when the target changes
  /// during animation.
  void updateTarget(double newTarget) {
    // Create a new animation with the current state as starting point
    final newAnimation = SpringAnimation(
      config: config,
      from: _currentValue,
      to: newTarget,
    );
    newAnimation._currentValue = _currentValue;
    newAnimation._currentVelocity = _currentVelocity;
    newAnimation._lastTime = _lastTime;
    newAnimation._isRunning = _isRunning;

    // Copy the new state back
    _currentValue = newAnimation._currentValue;
    _currentVelocity = newAnimation._currentVelocity;
    _lastTime = newAnimation._lastTime;
    _isRunning = newAnimation._isRunning;
  }

  /// Creates a spring animation that animates between 0.0 and 1.0.
  ///
  /// This is useful for creating normalized animations that can be
  /// used with interpolation functions.
  static SpringAnimation normalized({
    required SpringConfig config,
  }) {
    return SpringAnimation(
      config: config,
      from: 0.0,
      to: 1.0,
    );
  }

  @override
  String toString() {
    return 'SpringAnimation('
        'from: $from, '
        'to: $to, '
        'value: $_currentValue, '
        'velocity: $_currentVelocity, '
        'isRunning: $_isRunning)';
  }
}
