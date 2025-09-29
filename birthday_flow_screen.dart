import 'package:flutter/material.dart';
import 'cake_animation_page.dart';
import 'birthday_card_page.dart';
import 'gallery_page.dart';

class BirthdayFlowScreen extends StatefulWidget {
  final String username;

  const BirthdayFlowScreen({Key? key, required this.username})
      : super(key: key);

  @override
  _BirthdayFlowScreenState createState() => _BirthdayFlowScreenState();
}

class _BirthdayFlowScreenState extends State<BirthdayFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      CakeAnimationPage(
        onNext: () => _nextPage(),
        username: widget.username,
      ),
      BirthdayCardPage(
        onNext: () => _nextPage(),
        onPrevious: () => _previousPage(),
      ),
      GalleryPage(
        onPrevious: () => _previousPage(),
        username: widget.username,
      ),
    ]);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: _pages,
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: _currentPage == index ? 20 : 12,
                    height: 12,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(6),
                      color: _currentPage == index
                          ? Colors.yellow
                          : Colors.white.withOpacity(0.5),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
