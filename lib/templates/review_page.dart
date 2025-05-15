import 'package:flutter/material.dart';

// pagina prueba creada por Gemini
class ReviewFullPage extends StatelessWidget {
  final String posterUrl;
  final String title;
  final String username;
  final double rating;
  final String reviewText;
  final int likes;
  final int comments;

  const ReviewFullPage({
    super.key,
    required this.posterUrl,
    required this.title,
    required this.username,
    required this.rating,
    required this.reviewText,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(posterUrl),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Valoración: $rating',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              reviewText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.favorite),
                const SizedBox(width: 4),
                Text('$likes likes'),
                const SizedBox(width: 16),
                const Icon(Icons.chat_bubble),
                const SizedBox(width: 4),
                Text('$comments comentarios'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}