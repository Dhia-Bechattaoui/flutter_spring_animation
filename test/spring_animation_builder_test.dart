import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_spring_animation/src/spring_animation_builder.dart';
import 'package:flutter_spring_animation/src/spring_config.dart';

void main() {
  group('SpringAnimationBuilder', () {
    testWidgets('creates and displays widget correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SpringAnimationBuilder(
            config: SpringConfig(),
            target: 1.0,
            builder: (context, value) {
              return Container(
                width: 100 * value,
                height: 100 * value,
                color: Colors.blue,
              );
            },
          ),
        ),
      );

      // Widget should be built
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('updates when target changes', (tester) async {
      double currentTarget = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  SpringAnimationBuilder(
                    config: SpringConfig(),
                    target: currentTarget,
                    builder: (context, value) {
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.blue.withOpacity(value),
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentTarget = currentTarget == 0.0 ? 1.0 : 0.0;
                      });
                    },
                    child: Text('Toggle'),
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Tap the button to change target
      await tester.tap(find.text('Toggle'));
      await tester.pump();

      // Widget should still be present
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('disposes controller properly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SpringAnimationBuilder(
            config: SpringConfig(),
            target: 1.0,
            builder: (context, value) {
              return Container(color: Colors.blue);
            },
          ),
        ),
      );

      // Remove the widget
      await tester.pumpWidget(Container());

      // Should not throw any errors during disposal
      expect(tester.takeException(), isNull);
    });
  });

  group('SpringTransition', () {
    testWidgets('shows and hides child based on visible property',
        (tester) async {
      bool isVisible = true;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  SpringTransition(
                    visible: isVisible,
                    config: SpringConfig(),
                    child: Container(
                      key: Key('test-container'),
                      width: 100,
                      height: 100,
                      color: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    child: Text('Toggle'),
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Container should be present
      expect(find.byKey(Key('test-container')), findsOneWidget);

      // Toggle visibility
      await tester.tap(find.text('Toggle'));
      await tester.pump();

      // Container should still be in widget tree but possibly with different opacity
      expect(find.byKey(Key('test-container')), findsOneWidget);
    });
  });

  group('SpringSlideTransition', () {
    testWidgets('creates slide transition correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SpringSlideTransition(
            visible: true,
            direction: AxisDirection.up,
            config: SpringConfig(),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Transform), findsOneWidget);
    });

    testWidgets('handles different slide directions', (tester) async {
      for (final direction in AxisDirection.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: SpringSlideTransition(
              visible: true,
              direction: direction,
              config: SpringConfig(),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.green,
              ),
            ),
          ),
        );

        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(Transform), findsOneWidget);
      }
    });
  });

  group('SpringRotationTransition', () {
    testWidgets('creates rotation transition correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SpringRotationTransition(
            visible: true,
            turns: 0.25,
            config: SpringConfig(),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.yellow,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Transform), findsOneWidget);
    });

    testWidgets('handles custom turn values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SpringRotationTransition(
            visible: true,
            turns: 0.5, // 180 degrees
            config: SpringConfig(),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.yellow,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Transform), findsOneWidget);
    });
  });

  group('SpringSizeTransition', () {
    testWidgets('creates size transition correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SpringSizeTransition(
            visible: true,
            config: SpringConfig(),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.purple,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Transform), findsOneWidget);
    });

    testWidgets('handles horizontal axis constraint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SpringSizeTransition(
            visible: true,
            axis: Axis.horizontal,
            config: SpringConfig(),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.purple,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Transform), findsOneWidget);
    });

    testWidgets('handles vertical axis constraint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SpringSizeTransition(
            visible: true,
            axis: Axis.vertical,
            config: SpringConfig(),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.purple,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Transform), findsOneWidget);
    });
  });
}
