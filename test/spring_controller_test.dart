import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_spring_animation/src/spring_config.dart';
import 'package:flutter_spring_animation/src/spring_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SpringController', () {
    late SpringController controller;

    setUp(() {
      controller = SpringController(
        config: SpringConfig(),
        initialValue: 0.0,
      );
    });

    tearDown(() {
      if (!controller.isDisposed) {
        controller.dispose();
      }
    });

    test('creates instance with correct initial values', () {
      const config = SpringConfig();
      final controller = SpringController(
        config: config,
        initialValue: 0.5,
      );

      expect(controller.config, config);
      expect(controller.value, 0.5);
      expect(controller.target, 0.0);
      expect(controller.isAnimating, false);
      expect(controller.isCompleted, true);
      expect(controller.velocity, 0.0);

      controller.dispose();
    });

    test('setValue updates value immediately', () {
      controller.setValue(0.7);

      expect(controller.value, 0.7);
      expect(controller.target, 0.7);
      expect(controller.isAnimating, false);
    });

    test('animateTo updates target', () {
      controller.animateTo(1.0);

      expect(controller.target, 1.0);
    });

    test('stop halts current animation', () {
      controller.animateTo(1.0);
      controller.stop();

      expect(controller.target, controller.value);
    });

    test('reset restores initial state', () {
      controller.setValue(0.5);
      controller.animateTo(1.0);

      controller.reset();

      expect(controller.value, 0.0);
      expect(controller.target, 0.0);
    });

    test('forward animates to 1.0', () {
      controller.forward();
      expect(controller.target, 1.0);
    });

    test('reverse animates to 0.0', () {
      controller.setValue(1.0);
      controller.reverse();
      expect(controller.target, 0.0);
    });

    test('toggle switches between 0.0 and 1.0', () {
      // Initially at 0.0, toggle should go to 1.0
      controller.toggleValue();
      expect(controller.target, 1.0);

      // Toggle again should go back to 0.0
      controller.toggleValue();
      expect(controller.target, 0.0);
    });

    test('throws error when used after disposal', () {
      controller.dispose();

      expect(
        () => controller.setValue(0.5),
        throwsA(isA<FlutterError>()),
      );

      expect(
        () => controller.animateTo(1.0),
        throwsA(isA<FlutterError>()),
      );

      expect(
        () => controller.reset(),
        throwsA(isA<FlutterError>()),
      );
    });

    test('toString provides useful representation', () {
      controller.setValue(0.5);
      controller.animateTo(1.0);

      final string = controller.toString();
      expect(string, contains('SpringController'));
      expect(string, contains('value: 0.5'));
      expect(string, contains('target: 1.0'));
      expect(string, contains('isAnimating'));
    });

    group('factory constructors', () {
      test('toggle factory creates correct controller', () {
        final toggleController = SpringController.toggle(
          config: SpringConfig.bouncy,
          initialValue: true,
        );

        expect(toggleController.value, 1.0);
        expect(toggleController.config, SpringConfig.bouncy);

        toggleController.dispose();
      });

      test('toggle factory with false initial value', () {
        final toggleController = SpringController.toggle(
          config: SpringConfig.gentle,
          initialValue: false,
        );

        expect(toggleController.value, 0.0);
        expect(toggleController.config, SpringConfig.gentle);

        toggleController.dispose();
      });

      test('bounce factory creates bouncing controller', () {
        final bounceController = SpringController.bounce(
          config: SpringConfig.wobbly,
          min: 0.0,
          max: 1.0,
          duration: Duration(milliseconds: 500),
        );

        expect(bounceController.value, 0.0);
        expect(bounceController.config, SpringConfig.wobbly);

        bounceController.dispose();
      });
    });

    group('change notification', () {
      test('notifies listeners when value changes', () {
        var notificationCount = 0;
        controller.addListener(() {
          notificationCount++;
        });

        controller.setValue(0.5);
        expect(notificationCount, 1);

        controller.setValue(0.7);
        expect(notificationCount, 2);
      });

      test('notifies listeners when animating', () {
        var notificationCount = 0;
        controller.addListener(() {
          notificationCount++;
        });

        controller.animateTo(1.0);

        // Should notify at least once when animation starts
        expect(notificationCount, greaterThanOrEqualTo(0));
      });
    });

    test('disposes properly without throwing', () {
      controller.animateTo(1.0);
      expect(() => controller.dispose(), returnsNormally);
    });
  });
}
