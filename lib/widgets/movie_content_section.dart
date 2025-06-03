import 'package:flutter/material.dart';
import 'package:frontend/widgets/movies_related_widgets/custom_rating_bar.dart';

class MovieContentSection extends StatefulWidget {
  final double? userRating; // Puede ser null si no tiene rating
  final Map<String, dynamic> movie;

  const MovieContentSection({
    super.key,
    this.userRating,
    required this.movie,
  });

  @override
  State<MovieContentSection> createState() => _MovieContentSectionState();
}

class _MovieContentSectionState extends State<MovieContentSection> {
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
      mainAxisSize: MainAxisSize.min, // No ocupar más espacio vertical del necesario
      children: [
        // Póster
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            movie["posterUrl"], // URL ejemplo
            height: 435,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 30.0),
        // Iconos de acción
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: Icon(
                Icons.visibility_outlined,
                color: Theme.of(context).colorScheme.onSurface),
                onPressed: () {}
            ),
            IconButton(icon: Icon(
                Icons.favorite_border,
                color: Theme.of(context).colorScheme.onSurface
            ), onPressed: () {}),
            IconButton(icon: Icon(
                Icons.watch_later_outlined,
                color: Theme.of(context).colorScheme.onSurface
            ), onPressed: () {}),
            IconButton(icon: Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.onSurface
            ), onPressed: () {}),
          ],
        ),
        const SizedBox(height: 17.0),
        // Gotas (Estrellas)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 156,
              child: CustomRatingBar(
                initialRating: rating,
                ignoreGestures: false,
                itemSize: 27,
                onChanged: (newRating) {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 22.0),
        // Escribe una reseña
        // ESTO DEBE SER UN DESTINO A UN POPUP DONDE PUEDAS COLOCAR TU REVIEW, O QUE TE LLEVE A LA PARTE DE LA PAGINA DONDE LA ESCRIBAS
        Text (
          'Write a Review',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Color(0xFFF9F9F9),
              decoration: TextDecoration.underline),
        ),
      ],
    );
  }
}
