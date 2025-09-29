import 'package:flutter/material.dart';
import 'dart:math' as math;

class CandleAnimation extends StatefulWidget {
  @override
  _CandleAnimationState createState() => _CandleAnimationState();
}

class _CandleAnimationState extends State<CandleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flickerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true);

    _flickerAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.8, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 0.9), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.0), weight: 1),
    ]).animate(_controller);
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCandle(-50, 0),
            _buildCandle(-25, 100),
            _buildCandle(0, 200),
            _buildCandle(25, 100),
            _buildCandle(50, 0),
          ],
        );
      },
    );
  }

  Widget _buildCandle(double offset, int delay) {
    return Transform.translate(
      offset: Offset(offset, -40),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 10,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFFFF9C4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(0, -25),
            child: Transform.scale(
              scale: _flickerAnimation.value,
              child: Container(
                width: 16,
                height: 20,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.yellow,
                      Colors.orange,
                      Colors.red,
                    ],
                    stops: [0.1, 0.5, 1.0],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.6),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
