import 'package:flutter/material.dart';
import 'dart:math' as math;

class FireworksEffect extends StatefulWidget {
  final VoidCallback onComplete;

  const FireworksEffect({
    super.key,
    required this.onComplete,
  });

  @override
  State<FireworksEffect> createState() => _FireworksEffectState();
}

class _FireworksEffectState extends State<FireworksEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // 生成粒子
    for (int i = 0; i < 30; i++) {
      _particles.add(Particle(_random));
    }

    _controller.forward().then((_) {
      widget.onComplete();
    });
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
        return CustomPaint(
          painter: FireworksPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class Particle {
  final math.Random random;
  late double startX;
  late double startY;
  late double endX;
  late double endY;
  late Color color;
  late double size;

  Particle(this.random) {
    startX = 0.5;
    startY = 0.5;
    double angle = random.nextDouble() * 2 * math.pi;
    double distance = 0.1 + random.nextDouble() * 0.2;
    endX = startX + math.cos(angle) * distance;
    endY = startY + math.sin(angle) * distance;

    // 隨機顏色
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
    ];
    color = colors[random.nextInt(colors.length)];
    size = 3 + random.nextDouble() * 5;
  }
}

class FireworksPainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  FireworksPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      double currentX =
          particle.startX + (particle.endX - particle.startX) * progress;
      double currentY =
          particle.startY + (particle.endY - particle.startY) * progress;

      double opacity = 1.0 - progress;

      Paint paint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(currentX * size.width, currentY * size.height),
        particle.size * (1 - progress * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FireworksPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
