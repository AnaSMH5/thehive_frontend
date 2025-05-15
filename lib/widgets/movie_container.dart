import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_rating_bar.dart';

class MovieContainer extends StatelessWidget {
  final String imageUrl;
  final double rating; // De 0 a 5
  final Widget destination;

  const MovieContainer({
    super.key,
    required this.imageUrl,
    required this.rating,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination), // Usa el Widget destino
        );
      },
      child: Hero(
        tag: 'dash',
        child: Column(
          children: [
            Container(
              width: 186,
              height: 261,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFF9F9F9),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 156,
                    child: CustomRatingBar(
                      initialRating: rating,
                      ignoreGestures: true,
                      itemSize: 27,
                      onChanged: (newRating) {},
                    ),
                  ),
                ]
            ),
          ],
        ),
      ),
    );
  }
}