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
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // 生成更多粒子以覆蓋整個畫面
    for (int i = 0; i < 80; i++) {
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
    // 增加距離範圍，讓粒子能覆蓋整個畫面（從中心到邊緣）
    double distance = 0.2 + random.nextDouble() * 0.5;
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
      Colors.cyan,
      Colors.amber,
    ];
    color = colors[random.nextInt(colors.length)];
    size = 4 + random.nextDouble() * 8;
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
      // 使用緩動函數讓速度更快，更有張力，再加速2倍
      double fastProgress = (progress * 2).clamp(0.0, 1.0); // 加速2倍
      double easedProgress = fastProgress < 0.5
          ? 2 * fastProgress * fastProgress  // 加速
          : 1 - math.pow(-2 * fastProgress + 2, 2) / 2; // 減速
      
      double currentX =
          particle.startX + (particle.endX - particle.startX) * easedProgress;
      double currentY =
          particle.startY + (particle.endY - particle.startY) * easedProgress;

      // 調整透明度，讓效果更持久
      double opacity = 1.0 - (progress * 0.7);

      Paint paint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      // 粒子大小隨進度變化，但保持更明顯
      double particleSize = particle.size * (1 - progress * 0.3);
      
      canvas.drawCircle(
        Offset(currentX * size.width, currentY * size.height),
        particleSize,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FireworksPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
