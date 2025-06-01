import 'dart:convert';
import 'package:http/http.dart' as http;

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
}


/*
void testPopularMovies() async {
  final movieService = MovieService();
  final movies = await movieService.getPopularMovies();
  print(movies); // Muestra en consola la lista de películas populares
}
 */