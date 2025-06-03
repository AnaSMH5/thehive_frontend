import 'package:flutter/material.dart';
import 'package:frontend/widgets/movies_related_widgets/custom_rating_bar.dart';
import 'package:frontend/templates/review_page.dart';

class MovieReview extends StatefulWidget {
  final String posterUrl;
  final String title;
  final String username;
  final double rating;
  final String reviewText;
  final int likes;
  final int comments;

  const MovieReview({
    super.key,
    required this.posterUrl,
    required this.title,
    required this.username,
    required this.reviewText,
    required this.rating,
    required this.likes,
    required this.comments,
  });

  @override
  State<MovieReview> createState() => _MovieReviewState();
}

class _MovieReviewState extends State<MovieReview> {
  final bool _isExpanded = false;
  final int _maxLines = 3; // Número de líneas a mostrar inicialmente
  bool _isHoveringMostrarMas = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 508,
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del póster
          Container(
            width: 156,
            height: 231,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: NetworkImage(widget.posterUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Columna con la información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: const Color(0xFFF9F9F9),
                      ),
                ),
                const SizedBox(height: 8),
                // Usuario y rating
                Row(
                  children: [
                    Text(
                      widget.username,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: const Color(0xFFF9F9F9),
                          ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 27,
                      child: CustomRatingBar(
                        initialRating: widget.rating,
                        ignoreGestures: true,
                        itemSize: 27,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Reseña
                LayoutBuilder(
                  builder: (context, constraints) {
                    final textPainter = TextPainter(
                      text: TextSpan(
                        text: widget.reviewText,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFFF9F9F9),
                            ),
                      ),
                      maxLines: _isExpanded ? null : _maxLines,
                      textDirection: TextDirection.ltr,
                    )..layout(maxWidth: constraints.maxWidth);

                    final isOverflowing = textPainter.didExceedMaxLines;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.reviewText,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFFF9F9F9),
                                  ),
                          maxLines: _isExpanded ? null : _maxLines,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isOverflowing && !_isExpanded)
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) => setState(() {
                              _isHoveringMostrarMas = true;
                            }),
                            onExit: (_) => setState(() {
                              _isHoveringMostrarMas = false;
                            }),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReviewFullPage(
                                      posterUrl: widget.posterUrl,
                                      title: widget.title,
                                      username: widget.username,
                                      rating: widget.rating,
                                      reviewText: widget.reviewText,
                                      likes: widget.likes,
                                      comments: widget.comments,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Mostrar más',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: _isHoveringMostrarMas
                                          ? const Color(0xFF50B2C0)
                                          : const Color(0xFFF9F9F9),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                // Likes y Comentarios
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite,
                            color: Color(0xFFF9F9F9), size: 24),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.likes} likes',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.chat_bubble,
                            color: Color(0xFFF9F9F9), size: 24),
                        const SizedBox(width: 8),
                        Text(
                          widget.comments.toString(),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 508,
      height: 233.10,
      child: Stack(
        children: [
          // Poster de la película
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 156,
              height: 231,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: NetworkImage(widget.posterUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Título de la película
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 156),
            child:
              Positioned(
                left: 189,
                top: 0,
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: const Color(0xFFF9F9F9),
                  ),
                ),
              ),
          ),
          // Información del usuario y rating
          Positioned(
            left: 189,
            top: 42,
            child: SizedBox(
              width: 319,
              height: 33,
              child: Row(
                children: [
                  // Mostrar el username
                  Text(
                    widget.username,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: const Color(0xFFF9F9F9),
                    ),
                  ),
                  const Spacer(), // Para empujar la rating bar hacia la derecha
                  // Rating bar
                  SizedBox(
                    height: 27,
                    child: CustomRatingBar(
                      initialRating: widget.rating / 5 * 5,
                      ignoreGestures: true,
                      itemSize: 27,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Reseña
          Positioned(
            left: 201,
            top: 84,
            child: SizedBox( // Envolvemos el LayoutBuilder con un SizedBox
              width: 304, // El mismo ancho que tenías antes para el texto
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textPainter = TextPainter(
                    text: TextSpan(
                      text: widget.reviewText,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFF9F9F9),
                      ),
                    ),
                    maxLines: _isExpanded ? null : _maxLines,
                    textDirection: TextDirection.ltr,
                  )..layout(maxWidth: constraints.maxWidth);

                  final isOverflowing = textPainter.didExceedMaxLines;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.reviewText,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFF9F9F9),
                        ),
                        maxLines: _isExpanded ? null : _maxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isOverflowing && !_isExpanded)
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (event) {
                            setState(() {
                              _isHoveringMostrarMas = true;
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              _isHoveringMostrarMas = false;
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              // Navegar a la página de la review completa
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewFullPage(
                                    posterUrl: widget.posterUrl,
                                    title: widget.title,
                                    username: widget.username,
                                    rating: widget.rating,
                                    reviewText: widget.reviewText,
                                    likes: widget.likes,
                                    comments: widget.comments,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Mostrar más',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: _isHoveringMostrarMas
                                    ? const Color(0xFF50B2C0)
                                    : const Color(0xFFF9F9F9),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          // Likes
          Positioned(
            left: 201,
            top: 202,
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Color(0xFFF9F9F9), size: 24),
                const SizedBox(width: 8),
                Text(
                  '${widget.likes} likes',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
          // Comentarios
          Positioned(
            left: 450,
            top: 204.53,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Icon(Icons.chat_bubble, color: Color(0xFFF9F9F9), size: 24),
                  const SizedBox(width: 8),
                  Text(
                    widget.comments.toString(),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }*/
}
