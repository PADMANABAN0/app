import 'package:flutter/material.dart';
import '../widgets/confetti_animation.dart';
import '../services/gallery_service.dart';
import '../models/message_model.dart';

class BirthdayCardPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const BirthdayCardPage({
    Key? key,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  _BirthdayCardPageState createState() => _BirthdayCardPageState();
}

class _BirthdayCardPageState extends State<BirthdayCardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _cardFlipAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isCardOpen = false;
  final GalleryService _galleryService = GalleryService();
  List<BirthdayMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages = _galleryService.getMessages();
    if (_messages.isEmpty) {
      _messages = [
        BirthdayMessage(
          id: '1',
          title: 'Happy Birthday!',
          message:
              'Wishing you a day filled with happiness and a year filled with joy. May all your dreams and wishes come true! 🎂✨',
          createdAt: DateTime.now(),
          from: 'Your Friends & Family',
        ),
      ];
    }

    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _cardFlipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _contentFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.8, curve: Curves.elasticOut),
      ),
    );

    _openCard();
  }

  void _openCard() async {
    await Future.delayed(Duration(milliseconds: 500));
    _controller.forward();
    setState(() => _isCardOpen = true);
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF667eea)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ConfettiAnimation(),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_cardFlipAnimation.value * 3.14),
                  alignment: Alignment.center,
                  child: _isCardOpen ? _buildOpenCard() : _buildClosedCard(),
                );
              },
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: ElevatedButton.icon(
              onPressed: widget.onPrevious,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: Icon(Icons.arrow_back),
              label: Text('Back to Cake'),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: widget.onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: Icon(Icons.photo_library),
              label: Text('View Gallery'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClosedCard() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 300,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.red[700],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 25,
              spreadRadius: 5,
              offset: Offset(0, 10),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red[700]!, Colors.red[900]!],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 20,
              right: 20,
              child: Icon(Icons.favorite,
                  color: Colors.white.withOpacity(0.3), size: 40),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Icon(Icons.favorite,
                  color: Colors.white.withOpacity(0.3), size: 30),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.card_giftcard,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tap to Open',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your Birthday Card',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenCard() {
    return FadeTransition(
      opacity: _contentFadeAnimation,
      child: Container(
        width: 320,
        height: 450,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFf8f9fa), Color(0xFFe9ecef)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 5,
              offset: Offset(0, 15),
            ),
          ],
        ),
        child: PageView.builder(
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final message = _messages[index];
            return _buildMessageCard(message);
          },
        ),
      ),
    );
  }

  Widget _buildMessageCard(BirthdayMessage message) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cake,
            size: 50,
            color: Colors.pink,
          ),
          SizedBox(height: 20),
          Text(
            message.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                message.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Divider(color: Colors.grey[300]),
          SizedBox(height: 10),
          Text(
            'With lots of love,',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 5),
          Text(
            message.from ?? 'Your Friends & Family',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
