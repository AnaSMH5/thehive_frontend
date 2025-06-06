import 'package:flutter/material.dart';
import 'package:frontend/widgets/movies_related_widgets/custom_rating_bar.dart';
import 'package:frontend/templates/movie_details_page.dart';

class MovieContainer extends StatelessWidget {
  final Map<String, dynamic> movie;
  final int iteration;

  const MovieContainer({
    super.key,
    required this.movie,
    this.iteration = 0,
  });

  @override
  Widget build(BuildContext context) {
    final String? posterPath = movie['poster_path'];
    final String imageUrl = (posterPath != null && posterPath.isNotEmpty)
        ? 'https://image.tmdb.org/t/p/w300$posterPath'
        : '';
    final voteAverage = movie['vote_average'];
    final double rating = (voteAverage is num ? voteAverage.toDouble() : 0.0) / 2.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsPage(movieId: movie['id']),
          ),
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
