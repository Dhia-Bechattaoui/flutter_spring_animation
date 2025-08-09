import 'dart:math' as math;

/// Configuration class for spring animation parameters.
///
/// This class defines the physics properties of a spring animation including
/// damping, stiffness, mass, and initial velocity.
class SpringConfig {
  /// Creates a spring configuration with the specified parameters.
  ///
  /// [damping] controls how quickly the animation settles. Higher values
  /// result in less oscillation. Must be >= 0.
  ///
  /// [stiffness] controls how strong the spring force is. Higher values
  /// result in faster animations. Must be > 0.
  ///
  /// [mass] controls the inertia of the animated object. Higher values
  /// result in slower animations. Must be > 0.
  ///
  /// [velocity] is the initial velocity of the animation.
  ///
  /// [tolerance] is the threshold for considering the animation complete.
  const SpringConfig({
    this.damping = 26.0,
    this.stiffness = 160.0,
    this.mass = 1.0,
    this.velocity = 0.0,
    this.tolerance = 0.01,
  })  : assert(damping >= 0, 'Damping must be non-negative'),
        assert(stiffness > 0, 'Stiffness must be positive'),
        assert(mass > 0, 'Mass must be positive'),
        assert(tolerance > 0, 'Tolerance must be positive');

  /// The damping coefficient. Controls oscillation.
  final double damping;

  /// The spring stiffness. Controls animation speed.
  final double stiffness;

  /// The mass of the animated object. Controls inertia.
  final double mass;

  /// The initial velocity of the animation.
  final double velocity;

  /// The tolerance for considering the animation complete.
  final double tolerance;

  /// Creates a configuration for a bouncy spring animation.
  static const SpringConfig bouncy = SpringConfig(
    damping: 10.0,
    stiffness: 100.0,
    mass: 1.0,
  );

  /// Creates a configuration for a gentle spring animation.
  static const SpringConfig gentle = SpringConfig(
    damping: 30.0,
    stiffness: 120.0,
    mass: 1.0,
  );

  /// Creates a configuration for a wobbly spring animation.
  static const SpringConfig wobbly = SpringConfig(
    damping: 8.0,
    stiffness: 180.0,
    mass: 1.0,
  );

  /// Creates a configuration for a stiff spring animation.
  static const SpringConfig stiff = SpringConfig(
    damping: 26.0,
    stiffness: 210.0,
    mass: 1.0,
  );

  /// Creates a configuration for a slow spring animation.
  static const SpringConfig slow = SpringConfig(
    damping: 28.0,
    stiffness: 80.0,
    mass: 1.0,
  );

  /// Calculates if the spring is critically damped.
  bool get isCriticallyDamped {
    final criticalDamping = 2 * math.sqrt(stiffness * mass);
    return (damping - criticalDamping).abs() < 0.001;
  }

  /// Calculates if the spring is overdamped.
  bool get isOverdamped {
    final criticalDamping = 2 * math.sqrt(stiffness * mass);
    return damping > criticalDamping;
  }

  /// Calculates if the spring is underdamped.
  bool get isUnderdamped {
    final criticalDamping = 2 * math.sqrt(stiffness * mass);
    return damping < criticalDamping;
  }

  /// Calculates the natural frequency of the spring.
  double get naturalFrequency => math.sqrt(stiffness / mass);

  /// Calculates the damping ratio of the spring.
  double get dampingRatio => damping / (2 * math.sqrt(stiffness * mass));

  /// Creates a copy of this configuration with the given fields replaced.
  SpringConfig copyWith({
    double? damping,
    double? stiffness,
    double? mass,
    double? velocity,
    double? tolerance,
  }) {
    return SpringConfig(
      damping: damping ?? this.damping,
      stiffness: stiffness ?? this.stiffness,
      mass: mass ?? this.mass,
      velocity: velocity ?? this.velocity,
      tolerance: tolerance ?? this.tolerance,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SpringConfig &&
        other.damping == damping &&
        other.stiffness == stiffness &&
        other.mass == mass &&
        other.velocity == velocity &&
        other.tolerance == tolerance;
  }

  @override
  int get hashCode {
    return Object.hash(damping, stiffness, mass, velocity, tolerance);
  }

  @override
  String toString() {
    return 'SpringConfig('
        'damping: $damping, '
        'stiffness: $stiffness, '
        'mass: $mass, '
        'velocity: $velocity, '
        'tolerance: $tolerance)';
  }
}
