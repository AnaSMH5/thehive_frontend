import 'package:flutter/material.dart';

class PhraseHexagon extends StatelessWidget {
  final String phrase;

  const PhraseHexagon({
    super.key,
    required this.phrase,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/icons/colored_hexagon.png',
          fit: BoxFit.contain,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.4),
          child: Text(
            phrase,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF351904),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}