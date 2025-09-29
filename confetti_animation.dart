import 'package:flutter/material.dart';
import 'dart:math' as math;

class ConfettiAnimation extends StatefulWidget {
  @override
  _ConfettiAnimationState createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<ConfettiPiece> confettiPieces = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _initializeConfetti();
  }

  void _initializeConfetti() {
    for (int i = 0; i < 50; i++) {
      confettiPieces.add(ConfettiPiece(
        x: _random.nextDouble() * 400,
        y: _random.nextDouble() * 800,
        color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
        size: 4 + _random.nextDouble() * 6,
        speed: 1 + _random.nextDouble() * 3,
        angle: _random.nextDouble() * 2 * math.pi,
        rotationSpeed: (_random.nextDouble() * 0.1) - 0.05,
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
        // Update confetti positions
        _updateConfetti();

        return CustomPaint(
          painter: ConfettiPainter(confettiPieces, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }

  void _updateConfetti() {
    for (final confetti in confettiPieces) {
      // Update position with gravity effect
      confetti.y += confetti.speed;
      confetti.x +=
          math.sin(confetti.angle) * 0.5; // Add some horizontal movement
      confetti.angle += confetti.rotationSpeed;

      // Reset if out of screen
      if (confetti.y > MediaQuery.of(context).size.height + 50) {
        confetti.y = -50;
        confetti.x = _random.nextDouble() * MediaQuery.of(context).size.width;
        confetti.angle = _random.nextDouble() * 2 * math.pi;
      }
    }
  }
}

class ConfettiPiece {
  double x;
  double y;
  final Color color;
  final double size;
  final double speed;
  double angle;
  final double rotationSpeed;

  ConfettiPiece({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speed,
    required this.angle,
    required this.rotationSpeed,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiPiece> confettiPieces;
  final double animationValue;

  ConfettiPainter(this.confettiPieces, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final confetti in confettiPieces) {
      final paint = Paint()..color = confetti.color;

      canvas.save();
      canvas.translate(confetti.x, confetti.y);
      canvas.rotate(confetti.angle);

      // Draw confetti as various shapes for more variety
      final shapeType = (confetti.x.toInt() + confetti.y.toInt()) % 3;

      switch (shapeType) {
        case 0: // Rectangle
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: confetti.size,
              height: confetti.size / 2,
            ),
            paint,
          );
          break;
        case 1: // Circle
          canvas.drawCircle(
            Offset.zero,
            confetti.size / 2,
            paint,
          );
          break;
        case 2: // Triangle
          final path = Path();
          path.moveTo(0, -confetti.size / 2);
          path.lineTo(confetti.size / 2, confetti.size / 2);
          path.lineTo(-confetti.size / 2, confetti.size / 2);
          path.close();
          canvas.drawPath(path, paint);
          break;
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
