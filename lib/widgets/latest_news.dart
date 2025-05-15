import 'package:flutter/material.dart';
import 'package:frontend/widgets/news_card.dart';

/*
class LatestNews extends StatefulWidget {
  const LatestNews({super.key});

  @override
  _LatestNewsState createState() => _LatestNewsState();
}

class _LatestNewsState extends State<LatestNews> {
  List<Map<String, dynamic>> _newsList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLatestNews();
  }

  Future<void> _fetchLatestNews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Reemplaza la URL con el endpoint real de tu API
    final url = Uri.parse('https://streamhive-production.up.railway.app/api/news'); // Asegúrate de que este endpoint es correcto

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Si la respuesta es exitosa, decodifica el JSON
        final List<dynamic> data = json.decode(response.body);
        // Mapea los datos a una lista de Map<String, dynamic>
        final List<Map<String, dynamic>> news = data.map((item) {
          return {
            'imageUrl': item['imageUrl'] ?? 'https://via.placeholder.com/342x165', // Usa un valor por defecto si es nulo
            'section': item['section'] ?? 'General', // Valor por defecto
            'title': item['title'] ?? 'No Title', // Valor por defecto
          };
        }).toList();

        setState(() {
          _newsList = news;
          _isLoading = false;
        });
      } else {
        // Si la respuesta no es exitosa, guarda el error
        setState(() {
          _error = 'Error al cargar las noticias: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      // Si hay un error de conexión o cualquier otro error, guárdalo
      setState(() {
        _error = 'Error de conexión: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Muestra un indicador de carga mientras se obtienen los datos
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      // Muestra un mensaje de error si ocurre algún problema
      return Center(child: Text('Error: $_error'));
    }

    // Si no hay errores y los datos se cargan correctamente, muestra la lista de noticias
    return ListView.builder(
      itemCount: _newsList.length,
      itemBuilder: (context, index) {
        final newsItem = _newsList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0), // Añade un poco de espacio entre las tarjetas
          child: NewsCard(
            imageUrl: newsItem['imageUrl'],
            section: newsItem['section'],
            title: newsItem['title'],
            onTap: () {
              // Define la acción al hacer clic en la tarjeta.  Por ejemplo, navegar a una página de detalles.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(newsItem: newsItem), // Crea un NewsDetailPage
                ),
              );
            },
          ),
        );
      },
    );
  }
}*/

class LatestNews extends StatefulWidget {
  final Axis scrollDirection;

  const LatestNews({super.key, required this. scrollDirection});

  @override
  State<LatestNews> createState() => _LatestNewsState();
}

class _LatestNewsState extends State<LatestNews> {
  List<NewsCard> _defaultNews = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLatestNews();
  }

  Future<void> _fetchLatestNews() async {
    setState(() {
      _error = null;
    });

    _defaultNews = [
      NewsCard(
        imageUrl: 'https://th.bing.com/th/id/OIP.r4WsATN-ZpypH0VxtbOfjAHaLH?rs=1&pid=ImgDetMain',
        section: 'Estrenos',
        title: 'Nuevas Peliculas de esta semana',
        destination: const NewsDetailPage(), // Pasa el Widget destino
      ),
      NewsCard(
        imageUrl: 'https://th.bing.com/th/id/OIP.r4WsATN-ZpypH0VxtbOfjAHaLH?rs=1&pid=ImgDetMain',
        section: 'Rating',
        title: 'Mejores peliculas de la semana pasada',
        destination: const NewsDetailPage(),
      ),
      NewsCard(
        imageUrl: 'https://th.bing.com/th/id/OIP.r4WsATN-ZpypH0VxtbOfjAHaLH?rs=1&pid=ImgDetMain',
        section: 'Festivales',
        title: 'El segundo festival de la película en Colombia',
        destination: const NewsDetailPage(),
      ),
      NewsCard(
        imageUrl: 'https://th.bing.com/th/id/OIP.r4WsATN-ZpypH0VxtbOfjAHaLH?rs=1&pid=ImgDetMain',
        section: 'Premieres',
        title: 'Thunderbolts! - The New Avengers',
        destination: const NewsDetailPage(),
      ),
      NewsCard(
        imageUrl: 'https://th.bing.com/th/id/OIP.r4WsATN-ZpypH0VxtbOfjAHaLH?rs=1&pid=ImgDetMain',
        section: 'Premios',
        title: 'Nominaciones de los Oscars',
        destination: const NewsDetailPage(),
      ),
    ];
    setState(() {
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }

    return ListView.builder(
      // para que no interfiera con el SingleChildScrollView
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // la dirección en la que se va a encontrar, Axis.vertical o Axis.horizontal
      scrollDirection: widget.scrollDirection,
      itemCount: _defaultNews.length,
      itemBuilder: (context, int index) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: _defaultNews[index],
        );
      },
    );
  }
}
