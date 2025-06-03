import 'package:flutter/material.dart';
import 'package:frontend/widgets/navigation_widget/nav_bar_controller.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MovieDetailsPage extends StatefulWidget {
  final Map<String, dynamic> movie;

  const MovieDetailsPage({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const NavBarController(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trailer
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: (movie['trailerUrl'] != null && movie['trailerUrl'] != "")
                        ? YoutubePlayer(
                      controller: YoutubePlayerController.fromVideoId(
                        videoId: movie['trailerUrl'],
                        autoPlay: false,
                        params: const YoutubePlayerParams(
                          showControls: true,
                          showFullscreenButton: true,
                        ),
                      ),
                    )
                    // Si no hay trailer que muestre la imagen de fondo
                        : Image.network(
                      "https://image.tmdb.org/t/p/w500${movie['backdrop_path']}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Stack(
                    // Información película
                    children: [
                      Image.network(
                        movie["posterUrl"],
                        fit: BoxFit.cover,
                      ),
                    ]
                  ),
                  // Ratings & Interactions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("TMDB: ${movie['tmdbRating']}", style: TextStyle(color: Colors.grey)),
                      Text("Hive: ${movie['hiveRating']}", style: TextStyle(color: Colors.grey)),
                      Text("${movie['views']} views", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
                      IconButton(icon: Icon(Icons.comment), onPressed: () {}),
                      IconButton(icon: Icon(Icons.share), onPressed: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
