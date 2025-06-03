import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/services/movie.dart';
import 'package:intl/intl.dart';
class MovieInfoSection extends StatefulWidget {
  final double? userRating; // Puede ser null si no tiene rating
  final Movie movie;

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

    String formattedDate = "";
    if (movie.releaseDate.isNotEmpty) {
      DateTime parsedDate = DateTime.parse(movie.releaseDate);
      formattedDate = DateFormat("d 'de' MMMM 'de' yyyy", 'es_MX').format(parsedDate);
    }

    String formatRuntime(int minutes) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      if (hours > 0) {
        return '${hours}h ${mins}m';
      } else {
        return '${mins}m';
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título Original
        Text(
          movie.originalTitle,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 48),
        ),
        // Título en Español
        Opacity(
          opacity: 0.6,
          child: Text(
            movie.title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Color(0xFFF9F9F9),
            ),
          ),
        ),
        const SizedBox(height: 18.0),
        // Año y Duración
        Text(
          '$formattedDate • ${formatRuntime(movie.runtime ?? 0)}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Color(0xFFF9F9F9),
          ),
        ),
        const SizedBox(height: 12.0),
        // Géneros
        Wrap(
          spacing: 7,  // espacio horizontal entre tags
          runSpacing: 8,  // espacio vertical entre filas si hay más de una línea
          children: widget.movie.genres
              .map<Widget>((genre) => _buildGenreTag(context, genre))
              .toList(),
        ),
        const SizedBox(height: 12.0),
        // Frase para captar atención
        Text(
          movie.tagline,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Color(0xFFF9F9F9),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12.0),
        // Sinopsis
        Text(
          movie.synopsis,
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

  Widget _buildGenreTag(BuildContext context, String label){
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge,
      )
    );
  }

  Widget _buildRatingsSection(movie) {
    final Map<int, int> starVotes = {
      5: 1250, // Votos para 5 estrellas
      4: 830,  // Votos para 4 estrellas
      3: 310,  // Votos para 3 estrellas
      2: 120,  // Votos para 2 estrellas
      1: 290,  // Votos para 1 estrella
    };

    // Calculamos el máximo de votos en cualquier categoría para escalar las barras
    // Esto asegura que la barra más larga ocupe todo el ancho disponible para ella.
    // Si no hay votos, establecemos maxVotes en 1 para evitar división por cero.
    final int maxVotes = starVotes.isEmpty ? 1 : starVotes.values.reduce((currMax, votes) => votes > currMax ? votes : currMax);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RATINGS',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 5.0),
        // Contenedor para TMDb y THE HIVE
        Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildStarDistributionChart(starVotes: starVotes, maxVotesInCategories: maxVotes),
                  ),
                  const SizedBox(width: 25.0),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildRatingSource(movie.tmdbRating, "TMDB", Icons.star),
                        const SizedBox(height: 40),
                        _buildRatingSource(movie.hiveRating, "THE HIVE", CupertinoIcons.drop_fill),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Estadísticas de interacción (Vistas, Likes, etc.)
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildEngagementStat(Icons.visibility, movie.views.toString()),
                        const SizedBox(height: 14.0),
                        _buildEngagementStat(Icons.favorite, movie.likes.toString()),
                        const SizedBox(height: 14.0),
                        _buildEngagementStat(Icons.watch_later, movie.watchlist.toString()),
                        const SizedBox(height: 14.0),
                        _buildEngagementStat(Icons.chat_bubble, movie.reviews.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      ],
    );
  }

  // Widget auxiliar para el rating de TMDB y el de THE HIVE
  Widget _buildRatingSource(double rating, String source, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Rating + Source
        Column(
          children: [
            Text(
              rating.toStringAsFixed(1), // Mostrar rating con 1 decimal
              style: Theme.of(context).textTheme.displayLarge,),
            Text(source, style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
        const SizedBox(width: 10), // Espacio entre el texto y el ícono
        // Icono
        Icon(icon, color: const Color(0xFFECA204), size: 50),
      ],
    );
  }

  // Widget auxiliar para las estadísticas de interacción
  Widget _buildEngagementStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Para que la fila no ocupe más espacio del necesario
      children: [
        Icon(icon, color: const Color(0xFFF9F9F9), size: 25.0),
        const SizedBox(width: 6.0),
        Text(value, style:
          Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  // Construye la lista de filas para el gráfico de distribución de estrellas.
  Widget _buildStarDistributionChart({required Map<int, int> starVotes, required int maxVotesInCategories}) {
    if (starVotes.isEmpty) {
      return Center(
        child: Text(
          "No hay datos de calificación disponibles",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    List<Widget> ratingRows = [];
    // Iteramos de 5 estrellas hacia 1 estrella para mostrar en ese orden
    for (int starLevel = 5; starLevel >= 1; starLevel--) {
      ratingRows.add(
        _buildStarRatingRow(
          starLevel: starLevel,
          votes: starVotes[starLevel] ?? 0, // Obtenemos los votos para este nivel de estrella
          maxVotesInCategories: maxVotesInCategories,
        ),
      );
      // Añadimos un pequeño espacio entre las filas, excepto después de la última
      if (starLevel > 1) {
        ratingRows.add(const SizedBox(height: 6.0));
      }
    }

    return Column(
      children: ratingRows
    );
  }

  // Construye una fila individual para el gráfico de estrellas, mostrando:
  // Nivel de estrella | Barra de progreso | Cantidad de votos
  Widget _buildStarRatingRow({
    required int starLevel,
    required int votes,
    required int maxVotesInCategories,
  }) {
    // Calcula el porcentaje de la barra basado en los votos actuales y el máximo de votos
    final double barPercentage = (maxVotesInCategories == 0 || votes == 0) ? 0.0 : (votes / maxVotesInCategories);

    return Row(
      children: [
        // Nivel de estrella y el icono de estrella
        Text(
          '$starLevel',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(width: 4.0),
        const Icon(Icons.star, color:  Color(0xFFECA204), size: 16.0),
        const SizedBox(width: 10.0),

        // Barra de progreso
        Expanded(
          child: Container(
            height: 8.0, // Altura de la barra
            decoration: BoxDecoration(
              color: Colors.grey[700], // Color de fondo de la barra (la parte no llena)
              borderRadius: BorderRadius.circular(4.0),
            ),
            // Usamos Align y FractionallySizedBox para dibujar la parte llena de la barra
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: barPercentage, // El ancho es proporcional a los votos
                child: Container(
                  decoration: BoxDecoration(
                    color:  const Color(0xFFECA204), // Color de la barra llena
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10.0),

        // Cantidad de votos (texto)
        SizedBox(
          width: 45, // Ancho fijo para alinear los números de votos
          child: Text(
            '$votes',
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.right, // Alinea el texto a la derecha
          ),
        ),
      ],
    );
  }
}