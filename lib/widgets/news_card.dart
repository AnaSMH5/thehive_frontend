import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String section;
  final String title;
  final Widget destination; // Callback para la acción al hacer clic

  const NewsCard({
    super.key,
    required this.imageUrl,
    required this.section,
    required this.title,
    required this.destination, // Añade el callback requerido
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination), // Usa el Widget destino
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contenedor para la imagen
          Container(
            width: 362,
            height: 185,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(height: 8.0),
          // Etiqueta "SECTION"
          Align(
           alignment: Alignment.topLeft,
           child: Container(
             padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
             decoration: BoxDecoration(
               color: Theme.of(context).colorScheme.secondary,
               borderRadius: BorderRadius.circular(12.0),
             ),
             child: Text(
               section.toUpperCase(),
               style: Theme.of(context).textTheme.labelSmall,
             ),
           ),
          ),
          const SizedBox(height: 4.0),
          // Título de la noticia
          SizedBox(
            width: 342,
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

//  Widget para la página de detalles de noticias creado por Gemini
class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Noticia'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aquí iría la imagen de la noticia',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Sección de la Noticia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Título de la Noticia',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Aquí iría el contenido completo de la noticia...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
