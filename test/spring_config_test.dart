import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_spring_animation/src/spring_config.dart';

void main() {
  group('SpringConfig', () {
    test('creates instance with default values', () {
      const config = SpringConfig();

      expect(config.damping, 26.0);
      expect(config.stiffness, 160.0);
      expect(config.mass, 1.0);
      expect(config.velocity, 0.0);
      expect(config.tolerance, 0.01);
    });

    test('creates instance with custom values', () {
      const config = SpringConfig(
        damping: 10.0,
        stiffness: 100.0,
        mass: 2.0,
        velocity: 5.0,
        tolerance: 0.001,
      );

      expect(config.damping, 10.0);
      expect(config.stiffness, 100.0);
      expect(config.mass, 2.0);
      expect(config.velocity, 5.0);
      expect(config.tolerance, 0.001);
    });

    test('throws assertion error for invalid damping', () {
      expect(
        () => SpringConfig(damping: -1.0),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error for invalid stiffness', () {
      expect(
        () => SpringConfig(stiffness: 0.0),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => SpringConfig(stiffness: -1.0),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error for invalid mass', () {
      expect(
        () => SpringConfig(mass: 0.0),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => SpringConfig(mass: -1.0),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error for invalid tolerance', () {
      expect(
        () => SpringConfig(tolerance: 0.0),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => SpringConfig(tolerance: -1.0),
        throwsA(isA<AssertionError>()),
      );
    });

    group('preset configurations', () {
      test('bouncy preset has correct values', () {
        const config = SpringConfig.bouncy;
        expect(config.damping, 10.0);
        expect(config.stiffness, 100.0);
        expect(config.mass, 1.0);
      });

      test('gentle preset has correct values', () {
        const config = SpringConfig.gentle;
        expect(config.damping, 30.0);
        expect(config.stiffness, 120.0);
        expect(config.mass, 1.0);
      });

      test('wobbly preset has correct values', () {
        const config = SpringConfig.wobbly;
        expect(config.damping, 8.0);
        expect(config.stiffness, 180.0);
        expect(config.mass, 1.0);
      });

      test('stiff preset has correct values', () {
        const config = SpringConfig.stiff;
        expect(config.damping, 26.0);
        expect(config.stiffness, 210.0);
        expect(config.mass, 1.0);
      });

      test('slow preset has correct values', () {
        const config = SpringConfig.slow;
        expect(config.damping, 28.0);
        expect(config.stiffness, 80.0);
        expect(config.mass, 1.0);
      });
    });

    group('physics calculations', () {
      test('calculates natural frequency correctly', () {
        const config = SpringConfig(stiffness: 100.0, mass: 4.0);
        expect(config.naturalFrequency, 5.0);
      });

      test('calculates damping ratio correctly', () {
        const config = SpringConfig(
          damping: 20.0,
          stiffness: 100.0,
          mass: 1.0,
        );
        expect(config.dampingRatio, 1.0);
      });

      test('identifies critically damped spring', () {
        const config = SpringConfig(
          damping: 20.0, // 2 * sqrt(100 * 1) = 20
          stiffness: 100.0,
          mass: 1.0,
        );
        expect(config.isCriticallyDamped, true);
        expect(config.isOverdamped, false);
        expect(config.isUnderdamped, false);
      });

      test('identifies overdamped spring', () {
        const config = SpringConfig(
          damping: 25.0, // > 2 * sqrt(100 * 1) = 20
          stiffness: 100.0,
          mass: 1.0,
        );
        expect(config.isCriticallyDamped, false);
        expect(config.isOverdamped, true);
        expect(config.isUnderdamped, false);
      });

      test('identifies underdamped spring', () {
        const config = SpringConfig(
          damping: 15.0, // < 2 * sqrt(100 * 1) = 20
          stiffness: 100.0,
          mass: 1.0,
        );
        expect(config.isCriticallyDamped, false);
        expect(config.isOverdamped, false);
        expect(config.isUnderdamped, true);
      });
    });

    test('copyWith creates new instance with updated values', () {
      const original = SpringConfig();
      final copy = original.copyWith(
        damping: 15.0,
        stiffness: 200.0,
      );

      expect(copy.damping, 15.0);
      expect(copy.stiffness, 200.0);
      expect(copy.mass, original.mass);
      expect(copy.velocity, original.velocity);
      expect(copy.tolerance, original.tolerance);
    });

    test('equality operator works correctly', () {
      const config1 = SpringConfig(damping: 10.0, stiffness: 100.0);
      const config2 = SpringConfig(damping: 10.0, stiffness: 100.0);
      const config3 = SpringConfig(damping: 15.0, stiffness: 100.0);

      expect(config1 == config2, true);
      expect(config1 == config3, false);
    });

    test('hashCode is consistent', () {
      const config1 = SpringConfig(damping: 10.0, stiffness: 100.0);
      const config2 = SpringConfig(damping: 10.0, stiffness: 100.0);

      expect(config1.hashCode, config2.hashCode);
    });

    test('toString provides useful representation', () {
      const config = SpringConfig(
        damping: 10.0,
        stiffness: 100.0,
        mass: 2.0,
        velocity: 5.0,
        tolerance: 0.001,
      );

      final string = config.toString();
      expect(string, contains('SpringConfig'));
      expect(string, contains('damping: 10.0'));
      expect(string, contains('stiffness: 100.0'));
      expect(string, contains('mass: 2.0'));
      expect(string, contains('velocity: 5.0'));
      expect(string, contains('tolerance: 0.001'));
    });
  });
}
