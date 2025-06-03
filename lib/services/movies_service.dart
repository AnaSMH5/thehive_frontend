import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/services/movie.dart';

class MovieService {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _bearerToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMGI1MmY1YWE2YTRiZjRiM2YzODVkOTE3N2JjMzgwMSIsIm5iZiI6MTc0MzM0OTk3MS4wNzQsInN1YiI6IjY3ZTk2OGQzNzAwYTZhOTRjNmU1NWM1YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.RpFEw5d9p_0otO_H7kIi7nQc28z0vWayL8YSzf2UmCo';

  Future<List<dynamic>> _getMovies(String endpoint) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_bearerToken',
      'Content-Type': 'application/json;charset=utf-8',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Error fetching $endpoint: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getPopularMovies() async =>
      _getMovies('movie/popular');

  Future<List<dynamic>> getTopRated() async =>
      _getMovies('movie/top_rated?language=es&page=1');

  Future<List<dynamic>> getTrendingWeek() async =>
      _getMovies('trending/movie/week?language=es');

  Future<List<dynamic>> getMoviesByGenre(String genreId) async =>
      _getMovies('discover/movie?language=es&page=1&sort_by=popularity.desc&include_adult=false&with_genres=$genreId');

  Future<List<dynamic>> getPopularColombia() async {
    final year = DateTime.now().year;
    final url = Uri.parse('$_baseUrl/discover/movie?include_adult=false&include_video=false&language=es&page=1&region=CO&sort_by=popularity.desc&year=$year');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_bearerToken',
      'Content-Type': 'application/json;charset=utf-8',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'].take(10).toList();
    } else {
      throw Exception('Error getting popular movies in Colombia: ${response.statusCode}');
    }
  }

  // Películas por generos
  Future<List<dynamic>> getRomance() => getMoviesByGenre('10749,35');
  Future<List<dynamic>> getActionAdventure() => getMoviesByGenre('28,12');
  Future<List<dynamic>> getDrama() => getMoviesByGenre('18');
  Future<List<dynamic>> getScienceFiction() => getMoviesByGenre('878');
  Future<List<dynamic>> getHorror() => getMoviesByGenre('27');
  Future<List<dynamic>> getFamily() => getMoviesByGenre('10751');
  Future<List<dynamic>> getFantasy() => getMoviesByGenre('14');
  Future<List<dynamic>> getAnimated() => getMoviesByGenre('16');

  Future<Movie> getMovieDetails(int movieId) async {
    final urlDetails = Uri.parse('$_baseUrl/movie/$movieId?language=es');
    final urlTrailerEs = Uri.parse('$_baseUrl/movie/$movieId/videos?language=es-MX');
    final urlTrailerEn = Uri.parse('$_baseUrl/movie/$movieId/videos?language=en-US');
    final urlProviders = Uri.parse('$_baseUrl/movie/$movieId/watch/providers');
    final urlCredits = Uri.parse('$_baseUrl/movie/$movieId/credits?language=en-US');
    final urlAverageHive = Uri.parse('https://thehive-api.up.railway.app/api/v1/ratings/movie/$movieId/average');
    final urlRecommendations = Uri.parse('$_baseUrl/movie/$movieId/recommendations?language=es&page=1');

    try {
      final responses = await Future.wait([
        http.get(urlDetails, headers: {
          'Authorization': 'Bearer $_bearerToken',
          'Content-Type': 'application/json;charset=utf-8',
        }),
        http.get(urlTrailerEs, headers: {
          'Authorization': 'Bearer $_bearerToken',
          'Content-Type': 'application/json;charset=utf-8',
        }),
        http.get(urlTrailerEn, headers: {
          'Authorization': 'Bearer $_bearerToken',
          'Content-Type': 'application/json;charset=utf-8',
        }),
        http.get(urlProviders, headers: {
          'Authorization': 'Bearer $_bearerToken',
          'Content-Type': 'application/json;charset=utf-8',
        }),
        http.get(urlCredits, headers: {
          'Authorization': 'Bearer $_bearerToken',
          'Content-Type': 'application/json;charset=utf-8',
        }),
        http.get(urlAverageHive),
        http.get(urlRecommendations, headers: {
          'Authorization': 'Bearer $_bearerToken',
          'Content-Type': 'application/json;charset=utf-8',
        }),
      ]);


      final detailJson = json.decode(responses[0].body);
      final trailerEsJson = json.decode(responses[1].body);
      final trailerEnJson = json.decode(responses[2].body);
      final providersJson = json.decode(responses[3].body);
      final creditsJson = json.decode(responses[4].body);
      final hiveJson = json.decode(responses[5].body);
      final recommendationsJson = json.decode(responses[6].body);

      final trailerEsResults = (trailerEsJson['results'] as List<dynamic>?) ?? [];
      final trailerEnResults = (trailerEnJson['results'] as List<dynamic>?) ?? [];
      final creditsCast = (creditsJson['cast'] as List<dynamic>?) ?? [];
      final creditsCrew = (creditsJson['crew'] as List<dynamic>?) ?? [];
      final recommendations = (recommendationsJson['results'] as List<dynamic>?) ?? [];
      final genres = (detailJson['genres'] as List<dynamic>?) ?? [];
      final hiveAverage = (hiveJson['avg_rate'] ?? 0).toDouble();

      String? trailerId;
      for (final results in [trailerEsResults, trailerEnResults]) {
        final trailer = results.firstWhere(
              (video) =>
          video['site'] == 'YouTube' &&
              video['type'] == 'Trailer' &&
              video['key'] != null,
          orElse: () => null,
        );
        if (trailer != null) {
          trailerId = trailer['key'];
          break;
        }
      }

      return Movie(
        id: movieId,
        title: detailJson['title'] ?? '',
        backDropPath: detailJson['backdrop_path'] ?? '',
        originalTitle: detailJson['original_title'] ?? '',
        releaseDate: detailJson['release_date'] ?? '',
        runtime: detailJson['runtime'],
        tagline: detailJson['tagline'] ?? '',
        synopsis: detailJson['overview'] ?? '',
        posterUrl: "https://image.tmdb.org/t/p/w500${detailJson['poster_path'] ?? ''}",
        trailerId: trailerId ?? '',
        tmdbRating: (detailJson['vote_average'] ?? 0).toDouble() / 2,
        hiveRating: hiveAverage,
        recommendations: recommendations,
        genres: genres.map((g) => g['name'].toString()).toList(),
        views: 0,
        likes: 0,
        reviews: 0,
        watchlist: 0,
        watchProviders: providersJson['results'] is Map<String, dynamic> ? providersJson['results'] : {},
        cast: creditsCast.map((c) => {"name": c['name'], "character": c['character']}).toList(),
        crew: creditsCrew.map((c) => {"name": c['name'], "job": c['job']}).toList(),
      );
    } catch (e) {
      throw Exception('Error al obtener los detalles de la película: $e');
    }
  }
}


/*
void testPopularMovies() async {
  final movieService = MovieService();
  final movies = await movieService.getPopularMovies();
  print(movies); // Muestra en consola la lista de películas populares
}
 */