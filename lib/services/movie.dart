class Movie {
  final String title;
  final String backDropPath;
  final String originalTitle;
  final String posterUrl;
  final String trailerUrl;
  final String releaseDate;
  final int runtime;
  final String tagline;
  final String synopsis;
  final double tmdbRating; // Rating Average de TMDB
  final double hiveRating; // Rating Average de The Hive
  final List<dynamic> recommendations;
  final List<String> genres;
  final int views;
  final int likes;
  final int reviews;
  final int watchlist;

  Movie({
    required this.title,
    required this.backDropPath,
    required this.originalTitle,
    required this.posterUrl,
    required this.trailerUrl,
    required this.releaseDate,
    required this.runtime,
    required this.tagline,
    required this.synopsis,
    required this.tmdbRating,
    required this.hiveRating,
    required this.recommendations,
    required this.genres,
    required this.views,
    required this.likes,
    required this.reviews,
    required this.watchlist,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? '',
      backDropPath: json['backdrop_path'] ?? '',
      originalTitle: json['original_title'] ?? '',
      releaseDate: json['release_date'] ?? '',
      runtime: json['runtime'] ?? '',
      tagline: json['tagline'] ?? '',
      synopsis: json['overview'] ?? '',
      posterUrl: "https://image.tmdb.org/t/p/w500${json['poster_path']}",
      trailerUrl: json['videos']['results'].isNotEmpty
          ? "https://www.youtube.com/watch?v=${json['videos']['results'][0]['key']}"
          : "",
      tmdbRating: (json['vote_average'] ?? 0).toDouble() / 2,
      hiveRating: 0, // You can assign or calculate this later
      recommendations: [],
      // Obtener solo los nombres de los generos
      genres: (json['genres'] as List<dynamic>).map((g) => g['name'].toString()).toList(),
      views: 0,
      likes: 0,
      reviews: 0,
      watchlist: 0,
    );
  }
}