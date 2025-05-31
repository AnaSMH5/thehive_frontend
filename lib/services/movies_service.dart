import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _bearerToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMGI1MmY1YWE2YTRiZjRiM2YzODVkOTE3N2JjMzgwMSIsIm5iZiI6MTc0MzM0OTk3MS4wNzQsInN1YiI6IjY3ZTk2OGQzNzAwYTZhOTRjNmU1NWM1YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.RpFEw5d9p_0otO_H7kIi7nQc28z0vWayL8YSzf2UmCo';

  Future<List<dynamic>> getPopularMovies() async {
    final url = Uri.parse('$_baseUrl/movie/popular');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Error getting Popular Movies: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getTopRated() async {
    final url = Uri.parse('$_baseUrl/movie/top_rated?language=es&page=1');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Error getting Top Rated Movies: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getPopularColombia() async {
    int currentYear = DateTime.now().year;
    final url = Uri.parse('$_baseUrl/discover/movie?include_adult=true&include_video=false&language=es&page=1&region=CO&sort_by=popularity.desc&year=$currentYear');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'].take(10).toList();
    } else {
      throw Exception('Error getting Popular Movies in Colombia: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getTrendingWeek() async {
    final url = Uri.parse('$_baseUrl/trending/movie/week?language=es');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Error getting Trending Movies This Week: ${response.statusCode}');
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