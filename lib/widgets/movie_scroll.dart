import 'package:flutter/material.dart';
import 'package:frontend/services/movies_service.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MovieScroll extends StatelessWidget {
  const MovieScroll({super.key});

  Future<List<dynamic>> getMovies() async {
    try {
      final movies = await MovieService().getPopularColombia();
      return movies;
    } catch (e) {
      debugPrint('Error fetching movies: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No movies found.'));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Top 10 Popular Movies in Colombia This Year',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                Divider(
                  color: Color(0xFFF9F9F9),
                  thickness: 2,
                  indent: MediaQuery.of(context).size.width * 0.125,
                  endIndent: MediaQuery.of(context).size.width * 0.125,
                ),
                const SizedBox(height: 15),
                CarouselSlider.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, itemIndex, pageViewIndex) {
                    final movie = snapshot.data![itemIndex];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 300,
                        width: 200,
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w300${movie['poster_path']}',
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 300,
                    autoPlay: true,
                    viewportFraction: 0.25,
                    enlargeCenterPage: true,
                    pageSnapping: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlayAnimationDuration: const Duration(seconds: 10),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}