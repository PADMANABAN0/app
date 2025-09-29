import 'package:flutter/material.dart';
import 'dart:math' as math;

class BalloonAnimation extends StatefulWidget {
  @override
  _BalloonAnimationState createState() => _BalloonAnimationState();
}

class _BalloonAnimationState extends State<BalloonAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Balloon> balloons = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _initializeBalloons();
  }

  void _initializeBalloons() {
    final random = math.Random();
    for (int i = 0; i < 12; i++) {
      balloons.add(Balloon(
        color: Colors.primaries[random.nextInt(Colors.primaries.length)],
        left: random.nextDouble() * 400,
        speed: 1 + random.nextDouble() * 3,
        size: 20 + random.nextDouble() * 15,
        drift: random.nextDouble() * 2 - 1,
      ));
    }
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
          painter: BalloonPainter(balloons, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Balloon {
  final Color color;
  final double left;
  final double speed;
  final double size;
  final double drift;

  Balloon({
    required this.color,
    required this.left,
    required this.speed,
    required this.size,
    required this.drift,
  });
}

class BalloonPainter extends CustomPainter {
  final List<Balloon> balloons;
  final double animationValue;

  BalloonPainter(this.balloons, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < balloons.length; i++) {
      final balloon = balloons[i];
      final y = size.height -
          (animationValue * size.height * balloon.speed) % (size.height + 100);
      final x = balloon.left +
          math.sin(animationValue * 2 * math.pi + i) * balloon.drift * 20;

      if (y > -50) {
        final paint = Paint()..color = balloon.color;
        canvas.drawCircle(Offset(x, y), balloon.size, paint);

        final highlightPaint = Paint()..color = Colors.white.withOpacity(0.3);
        canvas.drawCircle(
          Offset(x - balloon.size * 0.3, y - balloon.size * 0.3),
          balloon.size * 0.2,
          highlightPaint,
        );

        final stringPaint = Paint()
          ..color = Colors.white
          ..strokeWidth = 1;
        canvas.drawLine(
          Offset(x, y + balloon.size),
          Offset(x, y + balloon.size + 40),
          stringPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
