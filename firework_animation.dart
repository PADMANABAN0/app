import 'package:flutter/material.dart';
import 'dart:math' as math;

class FireworkAnimation extends StatefulWidget {
  @override
  _FireworkAnimationState createState() => _FireworkAnimationState();
}

class _FireworkAnimationState extends State<FireworkAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Firework> fireworks = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();

    for (int i = 0; i < 3; i++) {
      _addFirework();
    }
  }

  void _addFirework() {
    fireworks.add(Firework(
      x: _random.nextDouble() * 400,
      y: 100 + _random.nextDouble() * 300,
      color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
      particles: 8 + _random.nextInt(12),
    ));
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
        if (_random.nextDouble() < 0.02) {
          _addFirework();
        }

        fireworks.removeWhere((firework) => firework.progress > 1.2);

        return CustomPaint(
          painter: FireworkPainter(fireworks, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Firework {
  final double x;
  final double y;
  final Color color;
  final int particles;
  double progress = 0;

  Firework({
    required this.x,
    required this.y,
    required this.color,
    required this.particles,
  });
}

class FireworkPainter extends CustomPainter {
  final List<Firework> fireworks;
  final double animationValue;

  FireworkPainter(this.fireworks, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final firework in fireworks) {
      firework.progress = (animationValue * 2) % 1.2;
      final radius = firework.progress * 40;
      final alpha = (1 - firework.progress).clamp(0.0, 1.0);

      if (firework.progress <= 1.0) {
        final paint = Paint()
          ..color = firework.color.withOpacity(alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawCircle(Offset(firework.x, firework.y), radius, paint);

        final particlePaint = Paint()
          ..color = firework.color.withOpacity(alpha * 0.7)
          ..style = PaintingStyle.fill;

        for (int i = 0; i < firework.particles; i++) {
          final angle = 2 * math.pi * i / firework.particles;
          final particleX = firework.x + math.cos(angle) * radius;
          final particleY = firework.y + math.sin(angle) * radius;
          canvas.drawCircle(Offset(particleX, particleY), 2, particlePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
