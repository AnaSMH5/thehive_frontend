import 'package:flutter/material.dart';
import 'package:frontend/widgets/movie_review.dart'; // Asegúrate de que la ruta sea correcta

class PopularMovieReviews extends StatefulWidget {
  final Axis scrollDirection;

  const PopularMovieReviews({super.key, required this. scrollDirection});

  @override
  State<PopularMovieReviews> createState() => _PopularMovieReviewsState();
}

class _PopularMovieReviewsState extends State<PopularMovieReviews> {
  List<MovieReview> _popularComments = [];
  String? _error;

  @override
  void initState() {
    super.initState();

    const mockMoviePosterUrl =
        'https://th.bing.com/th/id/OIP.r4WsATN-ZpypH0VxtbOfjAHaLH?rs=1&pid=ImgDetMain'; // Placeholder para el poster

    final List<MovieReview> mockComments = [
      MovieReview(
        key: UniqueKey(),
        posterUrl: mockMoviePosterUrl,
        title: 'Example Movie 1',
        username: 'User123',
        rating: 4.5,
        reviewText:
        'This is a great movie! I really enjoyed the plot and the acting.  The special effects were also top-notch. I would definitely recommend this to others.',
        likes: 125,
        comments: 30,
      ),
      MovieReview(
        key: UniqueKey(),
        posterUrl: mockMoviePosterUrl,
        title: 'Another Movie Title',
        username: 'FilmFan22',
        rating: 3.8,
        reviewText:
        'Not bad, but it had some pacing issues. The story was interesting, but the execution could have been better.',
        likes: 62,
        comments: 15,
      ),
      MovieReview(
        key: UniqueKey(),
        posterUrl: mockMoviePosterUrl,
        title: 'Best Movie Ever',
        username: 'CinemaLover',
        rating: 5.0,
        reviewText:
        'This movie is a masterpiece.  From the first scene to the last, I was completely captivated.  The acting, the directing, the music, everything was perfect.',
        likes: 200,
        comments: 50,
      ),
      MovieReview(
        key: UniqueKey(),
        posterUrl: mockMoviePosterUrl,
        title: 'Best Movie Ever',
        username: 'CinemaLover',
        rating: 5.0,
        reviewText:
        'This movie is a masterpiece.  From the first scene to the last, I was completely captivated.  The acting, the directing, the music, everything was perfect.',
        likes: 200,
        comments: 50,
      ),
      MovieReview(
        key: UniqueKey(),
        posterUrl: mockMoviePosterUrl,
        title: 'Best Movie Ever',
        username: 'CinemaLover',
        rating: 5.0,
        reviewText:
        'This movie is a masterpiece.  From the first scene to the last, I was completely captivated.  The acting, the directing, the music, everything was perfect.',
        likes: 200,
        comments: 50,
      ),
    ];

      setState(() {
        _popularComments = mockComments;
        _error = null; // Resetea el error
      });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }

    return ListView.builder(
      scrollDirection: widget.scrollDirection,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Evita conflicto con el scroll externo
      itemCount: _popularComments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: _popularComments[index],
        );
      },
    );
  }
}
