# Flutter Spring Animation

[![pub package](https://img.shields.io/pub/v/flutter_spring_animation.svg)](https://pub.dev/packages/flutter_spring_animation)
[![popularity](https://badges.bar/flutter_spring_animation/popularity)](https://pub.dev/packages/flutter_spring_animation/score)
[![likes](https://badges.bar/flutter_spring_animation/likes)](https://pub.dev/packages/flutter_spring_animation/score)
[![pub points](https://badges.bar/flutter_spring_animation/pub%20points)](https://pub.dev/packages/flutter_spring_animation/score)

A Flutter package for creating smooth spring-based animations with customizable damping, stiffness, and velocity parameters. Perfect for creating natural, physics-based UI transitions.

## Features

- 🌸 **Natural Spring Physics**: Realistic spring animations based on physics principles
- ⚙️ **Highly Customizable**: Adjust damping, stiffness, mass, and velocity parameters
- 🎯 **Easy to Use**: Simple API with both imperative and declarative approaches
- 🚀 **Performance Optimized**: Efficient animations that run at 60fps
- 📱 **Flutter Compatible**: Works with Flutter 3.10.0+
- 🎨 **Rich Widget Set**: Pre-built transition widgets for common use cases
- 🧪 **Well Tested**: Comprehensive test coverage
- 📚 **Fully Documented**: Complete API documentation and examples

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_spring_animation: ^0.0.1
```

Then run:

```bash
$ flutter pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:flutter_spring_animation/flutter_spring_animation.dart';

// Create a spring animation
final springAnimation = SpringAnimation(
  config: SpringConfig.bouncy,
  from: 0.0,
  to: 1.0,
);

// Start the animation
springAnimation.start(
  onUpdate: (value) {
    print('Current value: $value');
  },
  onComplete: () {
    print('Animation completed!');
  },
);
```

### Using SpringController

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late SpringController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SpringController(
      config: SpringConfig.gentle,
      initialValue: 0.0,
    );
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
        return Transform.scale(
          scale: 0.5 + (_controller.value * 0.5),
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
          ),
        );
      },
    );
  }

  void _animate() {
    _controller.animateTo(1.0);
  }
}
```

### Declarative Approach with SpringAnimationBuilder

```dart
SpringAnimationBuilder(
  config: SpringConfig.wobbly,
  target: isVisible ? 1.0 : 0.0,
  builder: (context, value) {
    return Opacity(
      opacity: value,
      child: Transform.scale(
        scale: value,
        child: Container(
          width: 100,
          height: 100,
          color: Colors.red,
        ),
      ),
    );
  },
)
```

## Spring Configurations

The package includes several pre-configured spring settings:

```dart
// Bouncy spring with some oscillation
SpringConfig.bouncy

// Gentle spring with smooth motion
SpringConfig.gentle

// Wobbly spring with more oscillation
SpringConfig.wobbly

// Stiff spring with quick motion
SpringConfig.stiff

// Slow spring with extended duration
SpringConfig.slow

// Custom configuration
SpringConfig(
  damping: 26.0,
  stiffness: 160.0,
  mass: 1.0,
  velocity: 0.0,
  tolerance: 0.01,
)
```

## Pre-built Transition Widgets

### SpringTransition

A general-purpose transition widget that combines opacity and scale animations:

```dart
SpringTransition(
  visible: isVisible,
  config: SpringConfig.bouncy,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.green,
  ),
)
```

### SpringSlideTransition

Slides widgets in from different directions:

```dart
SpringSlideTransition(
  visible: isVisible,
  direction: AxisDirection.up,
  config: SpringConfig.gentle,
  child: Text('Hello World!'),
)
```

### SpringRotationTransition

Rotates widgets with spring physics:

```dart
SpringRotationTransition(
  visible: isVisible,
  turns: 0.25, // 90 degrees
  config: SpringConfig.wobbly,
  child: Icon(Icons.star),
)
```

### SpringSizeTransition

Animates widget size with spring motion:

```dart
SpringSizeTransition(
  visible: isVisible,
  axis: Axis.horizontal, // or Axis.vertical, or null for both
  config: SpringConfig.stiff,
  child: Text('Expanding text'),
)
```

## Advanced Usage

### Custom Spring Physics

Understanding the spring parameters:

- **Damping**: Controls oscillation (higher = less bouncy)
- **Stiffness**: Controls animation speed (higher = faster)
- **Mass**: Controls inertia (higher = slower)
- **Velocity**: Initial velocity of the animation
- **Tolerance**: Threshold for animation completion

```dart
final customConfig = SpringConfig(
  damping: 15.0,    // Low damping for more bounce
  stiffness: 200.0, // High stiffness for quick response
  mass: 0.8,        // Light mass for snappy motion
  velocity: 5.0,    // Start with some initial velocity
);
```

### Chaining Animations

```dart
void chainAnimations() async {
  await _controller.animateTo(1.0);
  await _controller.animateTo(0.5);
  await _controller.animateTo(0.0);
}
```

### Toggle Animation

```dart
final toggleController = SpringController.toggle(
  config: SpringConfig.bouncy,
  initialValue: false,
);

// Toggle between states
toggleController.toggleValue();
```

### Bounce Animation

```dart
final bounceController = SpringController.bounce(
  config: SpringConfig.wobbly,
  min: 0.0,
  max: 1.0,
  duration: Duration(seconds: 1),
);
```

## Performance Tips

1. **Dispose controllers**: Always dispose SpringController instances in your widget's dispose method
2. **Reuse configurations**: Create SpringConfig instances once and reuse them
3. **Use tolerance**: Adjust tolerance values for your use case to avoid unnecessary calculations
4. **Avoid excessive updates**: Don't create new animations too frequently

## Examples

Check out the [example](example/) directory for a complete sample app demonstrating various use cases:

- Basic spring animations
- Interactive toggles
- List item animations
- Page transitions
- Custom physics demonstrations

To run the example:

```bash
cd example
flutter run
```

## API Reference

### SpringConfig

Configuration class for spring animation parameters.

**Properties:**
- `damping` (double): Damping coefficient (default: 26.0)
- `stiffness` (double): Spring stiffness (default: 160.0)
- `mass` (double): Mass of animated object (default: 1.0)
- `velocity` (double): Initial velocity (default: 0.0)
- `tolerance` (double): Completion tolerance (default: 0.01)

**Methods:**
- `copyWith()`: Create a copy with modified parameters
- Static presets: `bouncy`, `gentle`, `wobbly`, `stiff`, `slow`

### SpringAnimation

Core animation class implementing spring physics.

**Properties:**
- `value` (double): Current animation value
- `velocity` (double): Current velocity
- `isRunning` (bool): Whether animation is active
- `isCompleted` (bool): Whether animation has finished

**Methods:**
- `start()`: Begin animation with callbacks
- `stop()`: Stop current animation
- `reset()`: Reset to initial state
- `updateTarget()`: Change target during animation

### SpringController

ChangeNotifier-based controller for widget integration.

**Properties:**
- `value` (double): Current animation value
- `target` (double): Target value
- `isAnimating` (bool): Whether actively animating
- `velocity` (double): Current velocity

**Methods:**
- `animateTo()`: Animate to target value
- `setValue()`: Set value immediately
- `forward()`: Animate to 1.0
- `reverse()`: Animate to 0.0
- `toggleValue()`: Toggle between 0.0 and 1.0

### SpringAnimationBuilder

Widget builder for declarative animations.

**Parameters:**
- `config` (SpringConfig): Animation configuration
- `target` (double): Target value to animate to
- `builder` (Function): Widget builder function
- `initialValue` (double): Starting value (default: 0.0)

## Physics Background

This package implements a damped harmonic oscillator using the equation:

```
F = -kx - cv
```

Where:
- F is the force
- k is the spring constant (stiffness)
- x is the displacement from target
- c is the damping coefficient
- v is the velocity

The integration uses an improved Euler method for stability and performance.

## Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) and [code of conduct](CODE_OF_CONDUCT.md).

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Run tests: `flutter test`
6. Submit a pull request

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and changes.

## Support

- 📖 [Documentation](https://pub.dev/documentation/flutter_spring_animation/latest/)
- 🐛 [Issues](https://github.com/Dhia-Bechattaoui/flutter_spring_animation/issues)
- 💬 [Discussions](https://github.com/Dhia-Bechattaoui/flutter_spring_animation/discussions)

## Related Packages

- [animations](https://pub.dev/packages/animations) - Material motion animations
- [flutter_sequence_animation](https://pub.dev/packages/flutter_sequence_animation) - Sequence animations
- [simple_animations](https://pub.dev/packages/simple_animations) - Simple animation utilities

---

Made with ❤️ for the Flutter community
