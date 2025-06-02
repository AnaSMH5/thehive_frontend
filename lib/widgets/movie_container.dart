import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_rating_bar.dart';

class MovieContainer extends StatelessWidget {
  final Map<String, dynamic> movie;
  final Widget destination;
  final int iteration;

  const MovieContainer({
    super.key,
    required this.movie,
    required this.destination,
    this.iteration = 0,
  });

  @override
  Widget build(BuildContext context) {
    final String imageUrl = movie['poster_path'] != null
        ? 'https://image.tmdb.org/t/p/w300${movie['poster_path']}'
        : '';
    final double rating = (movie['vote_average'] as num).toDouble() / 2.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => destination), // Usa el Widget destino
        );
      },
      child: Hero(
        tag: 'movie_${iteration}_${movie['id']}',
        child: Column(
          children: [
            Container(
              width: 186,
              height: 261,
              decoration: ShapeDecoration(
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFF9F9F9),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: imageUrl.isEmpty
                  ? const Center(
                      child: Icon(Icons.broken_image, color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: 156,
                child: CustomRatingBar(
                  initialRating: rating,
                  ignoreGestures: true,
                  itemSize: 27,
                  onChanged: (newRating) {},
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
