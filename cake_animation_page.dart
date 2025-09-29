import 'package:flutter/material.dart';
import '../widgets/balloon_animation.dart';
import '../widgets/firework_animation.dart';
import '../widgets/candle_animation.dart';
import '../widgets/confetti_animation.dart';

class CakeAnimationPage extends StatefulWidget {
  final VoidCallback onNext;
  final String username;

  const CakeAnimationPage({
    Key? key,
    required this.onNext,
    required this.username,
  }) : super(key: key);

  @override
  _CakeAnimationPageState createState() => _CakeAnimationPageState();
}

class _CakeAnimationPageState extends State<CakeAnimationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  bool _showCandles = false;
  bool _showMessage = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Interval(0.7, 1.0, curve: Curves.easeOut)),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(Duration(milliseconds: 500));
    _controller.forward();

    await Future.delayed(Duration(milliseconds: 1500));
    setState(() => _showCandles = true);

    await Future.delayed(Duration(milliseconds: 1000));
    setState(() => _showMessage = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: FireworkAnimation()),
          Positioned.fill(child: BalloonAnimation()),
          Positioned.fill(child: ConfettiAnimation()),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildCake(),
                      if (_showCandles) CandleAnimation(),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                if (_showMessage)
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Text(
                                'Happy Birthday\n${widget.username}!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      color: Colors.yellow,
                                    ),
                                    Shadow(
                                      blurRadius: 20,
                                      color: Colors.orange,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: widget.onNext,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow,
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 8,
                                  shadowColor: Colors.yellow.withOpacity(0.5),
                                ),
                                child: Text(
                                  'Open Your Card 🎁',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCake() {
    return Container(
      width: 220,
      height: 140,
      child: Stack(
        children: [
          Positioned(
            bottom: -10,
            left: 40,
            child: Container(
              width: 140,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 35,
            child: Container(
              width: 150,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF8B4513),
                    Color(0xFFD2691E),
                    Color(0xFF8B4513)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 50,
            child: Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFDEB887),
                    Color(0xFFF5DEB3),
                    Color(0xFFDEB887)
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.3),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 90,
            left: 65,
            child: Container(
              width: 90,
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF5F5DC),
                    Color(0xFFFFF8DC),
                    Color(0xFFF5F5DC)
                  ],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Positioned(
            bottom: 85,
            left: 40,
            child: Container(
              width: 140,
              height: 25,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF08080),
                    Color(0xFFFFB6C1),
                    Color(0xFFF08080)
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 88,
            left: 50,
            child: Row(
              children: [
                _buildCakeDecoration(Colors.red),
                _buildCakeDecoration(Colors.blue),
                _buildCakeDecoration(Colors.green),
                _buildCakeDecoration(Colors.yellow),
                _buildCakeDecoration(Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCakeDecoration(Color color) {
    return Container(
      width: 8,
      height: 8,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
