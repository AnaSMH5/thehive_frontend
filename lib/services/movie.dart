class Movie {
  final int id;
  final String title;
  final String backDropPath;
  final String originalTitle;
  final String posterUrl;
  final String trailerId;
  final String releaseDate;
  final int? runtime;
  final String tagline;
  final String synopsis;
  final double tmdbRating; // Rating Average de TMDB (0-5 estrellas)
  final double hiveRating; // Rating Average de The Hive
  final List<dynamic> recommendations;
  final List<String> genres;
  final int views;
  final int likes;
  final int reviews;
  final int watchlist;
  final Map<String, dynamic> watchProviders;
  final List<Map<String, dynamic>> cast;
  final List<Map<String, dynamic>> crew;

  Movie({
    required this.id,
    required this.title,
    required this.backDropPath,
    required this.originalTitle,
    required this.posterUrl,
    required this.trailerId,
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
    required this.watchProviders,
    required this.cast,
    required this.crew,
  });
}