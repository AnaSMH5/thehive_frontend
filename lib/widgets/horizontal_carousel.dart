import 'package:flutter/material.dart';

class HorizontalCarousel extends StatelessWidget {
  final List<Widget> children;
  final double horizontalPadding;
  final double spacing;
  final ScrollController controller;
  final double scrollOffset;
  final String title;

  const HorizontalCarousel({
    super.key,
    required this.children,
    this.horizontalPadding = 200.0,
    this.spacing = 25.0,
    required this.controller,
    this.scrollOffset = 600.0,
    this.title = '',
  });

  void _scrollLeft() {
    controller.animateTo(
      controller.offset - scrollOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _scrollRight() {
    controller.animateTo(
      controller.offset + scrollOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Flechas
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFF9F9F9)),
                onPressed: _scrollLeft,
              ),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.left,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFFF9F9F9)),
                onPressed: _scrollRight,
              ),
            ],
          ),
        ),
        // Línea
        Divider(
          color: Color(0xFFF9F9F9),
          thickness: 2,
          indent: MediaQuery.of(context).size.width * 0.125,
          endIndent: MediaQuery.of(context).size.width * 0.125,
        ),
        // Scroll horizontal
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: controller,
            child: Row(
              // COLOCARLE QUE SI LE DOY CLIC AL CHILD ME LLEVE A UNA DIRECCIÓN
                children: List.generate(children.length, (i) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: spacing, // Padding derecho entre ellos
                    ),
                    child: children[i],
                  );
                })
            ),
          ),
        ),
      ],
    );
  }
}
