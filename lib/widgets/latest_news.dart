import 'package:flutter/material.dart';
import 'package:frontend/widgets/news_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LatestNews extends StatelessWidget {
  final Axis scrollDirection;

  const LatestNews({
    super.key,
    required this. scrollDirection,
  });

  Future<List<dynamic>> fetchLatestNewsletter() async {
    try {
      final url = Uri.parse('https://thehive-api.up.railway.app/api/v1/articles/newsletter/latest');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final sectionList = data['data'] ?? []; // Usamos un valor vacío por si no existe o está vacío
        // Si newsletters está vacío, devuelve una lista vacía
        List<dynamic> allArticles = [];

        for (var section in sectionList) {
          final sectionName = section['section'] ?? 'No Section';
          final articles = section['articles'] ?? [];

          for (var article in articles) {
            // Añade el nombre de la sección a cada artículo
            article['section'] = sectionName;
            allArticles.add(Map<String, dynamic>.from(article));
          }
        }

        if (allArticles.isEmpty) {
          debugPrint('No hay artículos disponibles.');
        }

        return allArticles; // Retorna los articulos que existen
      } else {
        throw Exception('Error getting Latest News: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en fetchLatestNewsletter: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder <List<dynamic>>(
        future: fetchLatestNewsletter(),
        builder: (context, snapshot) {
          // snapshot contiene el estado de future, connectionState muestra si está esperando, completado o falló.
          // Si todavía no terminó la carga, muestra un icono y reserva el espacio
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error Loading Latest News: ${snapshot.error}');
          }
          // snapshot.data! contiene la lista de películas
          final newsList = snapshot.data!;
          return ListView.builder(
            // para que no interfiera con el SingleChildScrollView
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            // la dirección en la que se va a encontrar, Axis.vertical o Axis.horizontal
            scrollDirection: scrollDirection,
            itemCount: newsList.length,
            itemBuilder: (context, int index) {
              final newsItem = newsList[index];

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: NewsCard(
                  imageUrl: newsItem['image_url'] ?? 'https://via.placeholder.com/150',
                  section: newsItem['section'],
                  title: newsItem['title'] ?? 'No Title',
                  destination: const NewsDetailPage(), // Pasa el Widget destino
                ),
              );
            },
          );
        },
    );
  }
}
