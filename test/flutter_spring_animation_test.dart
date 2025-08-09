import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_spring_animation/flutter_spring_animation.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('flutter_spring_animation library', () {
    test('exports SpringConfig', () {
      expect(SpringConfig, isNotNull);
      expect(SpringConfig.bouncy, isA<SpringConfig>());
    });

    test('exports SpringAnimation', () {
      expect(SpringAnimation, isNotNull);

      final animation = SpringAnimation(
        config: SpringConfig(),
        from: 0.0,
        to: 1.0,
      );
      expect(animation, isA<SpringAnimation>());
    });

    test('exports SpringController', () {
      expect(SpringController, isNotNull);

      final controller = SpringController(config: SpringConfig());
      expect(controller, isA<SpringController>());
      controller.dispose();
    });

    test('exports SpringAnimationBuilder', () {
      expect(SpringAnimationBuilder, isNotNull);
    });

    test('all main classes are accessible', () {
      // Test that we can create instances of all exported classes
      const config = SpringConfig.gentle;

      final animation = SpringAnimation(
        config: config,
        from: 0.0,
        to: 1.0,
      );

      final controller = SpringController(config: config);

      expect(config, isA<SpringConfig>());
      expect(animation, isA<SpringAnimation>());
      expect(controller, isA<SpringController>());

      controller.dispose();
    });

    test('preset configurations are accessible', () {
      expect(SpringConfig.bouncy, isA<SpringConfig>());
      expect(SpringConfig.gentle, isA<SpringConfig>());
      expect(SpringConfig.wobbly, isA<SpringConfig>());
      expect(SpringConfig.stiff, isA<SpringConfig>());
      expect(SpringConfig.slow, isA<SpringConfig>());
    });

    test('normalized animation factory is accessible', () {
      final animation = SpringAnimation.normalized(
        config: SpringConfig.bouncy,
      );

      expect(animation.from, 0.0);
      expect(animation.to, 1.0);
    });

    test('controller factory methods are accessible', () {
      final toggleController = SpringController.toggle(
        config: SpringConfig.gentle,
        initialValue: true,
      );

      expect(toggleController.value, 1.0);
      toggleController.dispose();

      final bounceController = SpringController.bounce(
        config: SpringConfig.wobbly,
        min: 0.0,
        max: 1.0,
        duration: Duration(milliseconds: 500),
      );

      expect(bounceController.value, 0.0);
      bounceController.dispose();
    });
  });
}
