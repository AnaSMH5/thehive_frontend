import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MovieInfoSection extends StatefulWidget {
  final double? userRating; // Puede ser null si no tiene rating
  final Map<String, dynamic> movie;

  const MovieInfoSection({
    super.key,
    this.userRating,
    required this.movie,
  });

  @override
  State<MovieInfoSection> createState() => _MovieInfoSectionState();
}

class _MovieInfoSectionState extends State<MovieInfoSection> {
  late double rating;

  @override
  void initState() {
    super.initState();
    rating = widget.userRating ?? 0.0; // Si no tiene rating, empieza en 0
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título Original
        Text(
          movie["originalTitle"],
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 48),
        ),
        // Título en Español
        Opacity(
          opacity: 0.6,
          child: Text(
            movie["title"],
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Color(0xFFF9F9F9),
            ),
          ),
        ),
        const SizedBox(height: 18.0),
        // Año y Duración
        Text(
          '${movie["releaseDate"] ?? ""} • ${movie["runtime"] ?? ""}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Color(0xFFF9F9F9),
          ),
        ),
        const SizedBox(height: 12.0),
        // Géneros
        Row(
          // Por cada genero crea un chip
          children: widget.movie['genres']
              .map<Widget>((genre) => _buildGenreChip(context, genre))
              .toList(),
        ),
        const SizedBox(height: 12.0),
        // Frase para captar atención
        Text(
          movie["tagline"],
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Color(0xFFF9F9F9),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12.0),
        // Sinopsis
        Text(
          movie["synopsis"],
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Color(0xFFF9F9F9),
            height: 1.5, // interlineado
          ),
        ),
        const SizedBox(height: 20.0),
        // Sección de Ratings
        _buildRatingsSection(movie),
      ],
    );
  }

  Widget _buildGenreChip(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0), // Espacio entre chips
      child: Chip(
        label: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide.none, // Sin borde
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
      ),
    );
  }

  Widget _buildRatingsSection(movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RATINGS',
          style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        // Contenedor para TMDb y THE HIVE
        Container(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRatingSource("3.1", "TMDB", Icons.star), // Icono de ejemplo
                  const SizedBox(height: 40),
                  _buildRatingSource("3.1", "THE HIVE",  CupertinoIcons.drop_fill), // Icono de ejemplo
                ],
              ),
              const SizedBox(height: 16.0),
              // Estadísticas de interacción (Vistas, Likes, etc.)
              // Estas parecen estar en dos columnas o una cuadrícula, usaremos Wrap para simplicidad.
              Column(
                children: [
                  _buildEngagementStat(Icons.visibility, movie["views"]),
                  const SizedBox(height: 14.0),
                  _buildEngagementStat(Icons.favorite, "206"),
                  const SizedBox(height: 14.0),
                  _buildEngagementStat(Icons.watch_later, "707"),
                  const SizedBox(height: 14.0),
                  _buildEngagementStat(Icons.chat_bubble, "1k"),
                  const SizedBox(height: 14.0),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget auxiliar para el rating de TMDB y el de THE HIVE
  Widget _buildRatingSource(String rating, String source, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Rating + Source
        Column(
          children: [
            Text(rating, style: Theme.of(context).textTheme.displayLarge,),
            Text(source, style: Theme.of(context).textTheme.labelMedium,),
          ],
        ),
        const SizedBox(width: 10), // Espacio entre el texto y el ícono
        // Icono
        Icon(icon, color: const Color(0xFFF9F9F9), size: 50),
      ],
    );
  }

  // Widget auxiliar para las estadísticas de interacción
  Widget _buildEngagementStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Para que la fila no ocupe más espacio del necesario
      children: [
        Icon(icon, color: Colors.white70, size: 18.0),
        const SizedBox(width: 6.0),
        Text(value, style: const TextStyle(color: Colors.white70, fontSize: 14.0)),
      ],
    );
  }
}