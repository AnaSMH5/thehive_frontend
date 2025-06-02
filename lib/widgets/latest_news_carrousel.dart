import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class LatestNewsCarrousel extends StatefulWidget {
  const LatestNewsCarrousel({super.key});

  @override
  State<LatestNewsCarrousel> createState() => _LatestNewsCarrouselState();
}

class _LatestNewsCarrouselState extends State<LatestNewsCarrousel> {
  PageController pageController = PageController(
    viewportFraction: 1.0,
    initialPage: 0,
  );
  var _currPageValue = 0.0;
  final _height = 550.0;
  Timer? _autoScrollTimer;
  final int _pageCount = 5; // Update if your itemCount changes

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      int nextPage = (pageController.page!.round() + 1) % _pageCount;
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      margin: EdgeInsets.symmetric(horizontal: 200),
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: _pageCount,
            itemBuilder: (context, position) {
              return _buildPageItem(position);
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: DotsIndicator(
              dotsCount: _pageCount,
              position: _currPageValue,
              decorator: DotsDecorator(
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                activeColor: Colors.white,
                color: Colors.grey,
                spacing: const EdgeInsets.symmetric(horizontal: 4.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPageItem(int position) {
    Matrix4 matrix = Matrix4.identity();
    if (position == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - position) * (1 - 0.9);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0.0, currTrans, 0.0);
    } else if (position == _currPageValue.floor() + 1) {
      var currScale = 0.9 + (_currPageValue - position + 1) * (1 - 0.9);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0.0, currTrans, 0.0);
    } else if (position == _currPageValue.floor() - 1) {
      var currScale = 0.9 + (_currPageValue - position - 1) * (1 - 0.9);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0.0, currTrans, 0.0);
    } else {
      matrix = Matrix4.diagonal3Values(1, 0.9, 1)
        ..setTranslationRaw(0.0, 100.0, 0.0);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/image_article_test.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(67, 0, 0, 0),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'NEWSLETTER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  'Latest News Title $position',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontFamily: 'Aboreto',
                  ),
                ),
                //SizedBox(height: 10),
                Text(
                  'By Author Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Jost',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
