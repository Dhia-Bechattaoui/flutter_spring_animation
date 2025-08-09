import 'package:flutter/material.dart';
import 'package:flutter_spring_animation/flutter_spring_animation.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget demonstrating spring animations.
class MyApp extends StatelessWidget {
  /// Creates the main app widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spring Animation Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SpringAnimationDemo(),
    );
  }
}

/// Main demo page showcasing different spring animation features.
class SpringAnimationDemo extends StatefulWidget {
  /// Creates the demo page.
  const SpringAnimationDemo({super.key});

  @override
  State<SpringAnimationDemo> createState() => _SpringAnimationDemoState();
}

class _SpringAnimationDemoState extends State<SpringAnimationDemo> {
  late SpringController _scaleController;
  late SpringController _rotationController;
  late SpringController _slideController;

  bool _isVisible = false;
  bool _isToggled = false;
  SpringConfig _currentConfig = SpringConfig.bouncy;

  @override
  void initState() {
    super.initState();
    _scaleController = SpringController(
      config: SpringConfig.bouncy,
      initialValue: 0.0,
    );
    _rotationController = SpringController(
      config: SpringConfig.wobbly,
      initialValue: 0.0,
    );
    _slideController = SpringController(
      config: SpringConfig.gentle,
      initialValue: 0.0,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Spring Animation Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildConfigSelector(),
            const SizedBox(height: 24),
            _buildBasicAnimations(),
            const SizedBox(height: 24),
            _buildTransitionWidgets(),
            const SizedBox(height: 24),
            _buildInteractiveDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spring Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _configChip('Bouncy', SpringConfig.bouncy),
                _configChip('Gentle', SpringConfig.gentle),
                _configChip('Wobbly', SpringConfig.wobbly),
                _configChip('Stiff', SpringConfig.stiff),
                _configChip('Slow', SpringConfig.slow),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Current: Damping=${_currentConfig.damping}, '
              'Stiffness=${_currentConfig.stiffness}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _configChip(String label, SpringConfig config) {
    final isSelected = _currentConfig == config;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _currentConfig = config;
          });
        }
      },
    );
  }

  Widget _buildBasicAnimations() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Animations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAnimatedBox(
                  'Scale',
                  _scaleController,
                  (value) => Transform.scale(
                    scale: 0.5 + (value * 0.5),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                _buildAnimatedBox(
                  'Rotation',
                  _rotationController,
                  (value) => Transform.rotate(
                    angle: value * 2 * 3.14159,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                _buildAnimatedBox(
                  'Slide',
                  _slideController,
                  (value) => Transform.translate(
                    offset: Offset(0, (1 - value) * 50),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBox(
    String label,
    SpringController controller,
    Widget Function(double) builder,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          child: Center(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) => builder(controller.value),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            controller.toggleValue();
          },
          child: Text(label),
        ),
      ],
    );
  }

  Widget _buildTransitionWidgets() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transition Widgets',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Visible: '),
                Switch(
                  value: _isVisible,
                  onChanged: (value) {
                    setState(() {
                      _isVisible = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SpringTransition(
                  visible: _isVisible,
                  config: _currentConfig,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
                  ),
                ),
                SpringSlideTransition(
                  visible: _isVisible,
                  direction: AxisDirection.up,
                  config: _currentConfig,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      color: Colors.white,
                    ),
                  ),
                ),
                SpringRotationTransition(
                  visible: _isVisible,
                  turns: 0.25,
                  config: _currentConfig,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                ),
                SpringSizeTransition(
                  visible: _isVisible,
                  config: _currentConfig,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.zoom_in,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interactive Demo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Tap the button to toggle the spring animation:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Center(
              child: SpringAnimationBuilder(
                config: _currentConfig,
                target: _isToggled ? 1.0 : 0.0,
                builder: (context, value) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _isToggled = !_isToggled;
                      });
                    },
                    child: Container(
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue,
                            Color.lerp(Colors.blue, Colors.purple, value)!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2 * value),
                            blurRadius: 10 * value,
                            offset: Offset(0, 5 * value),
                          ),
                        ],
                      ),
                      child: Transform.scale(
                        scale: 0.9 + (0.1 * value),
                        child: Center(
                          child: Text(
                            _isToggled ? 'ON' : 'OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Animation Value: ${(_isToggled ? 1.0 : 0.0).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
