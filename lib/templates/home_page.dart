import 'package:flutter/material.dart';
import 'package:frontend/widgets/navigation_bar.dart';
import 'package:frontend/widgets/register_button.dart';
import 'package:frontend/widgets/movie_container.dart';
import 'package:frontend/widgets/horizontal_carousel.dart';
import 'package:frontend/widgets/phrase_hexagon.dart';
import 'package:frontend/widgets/popular_movie_reviews.dart';
import 'package:frontend/widgets/latest_news.dart';
import 'package:frontend/widgets/footer.dart';
import 'package:frontend/widgets/news_card.dart';
import 'package:frontend/movies.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final MovieService _movieService = MovieService();
  late Future<List<dynamic>> _popularMovies;

  @override
  void initState() {
    super.initState();
    _popularMovies = _movieService.getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomNavigationBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 650,
                    child: Stack(
                      fit: StackFit.loose,
                      // Background
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Image.asset(
                              'assets/icons/home_page_background_image.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        // Name: 'The Hive'
                        Positioned(
                          top: 350,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'THE HIVE',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Aboreto',
                                  fontSize: 120,
                                  color: Theme.of(context).colorScheme.error,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color:
                                          Colors.black.withValues(alpha: 0.5),
                                      offset: const Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                              // Text
                              Text(
                                'RATE, SHARE AND DISCOVER',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      height: 0.1,
                                    ),
                              ),
                              const SizedBox(height: 50),
                              const RegisterButton(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Popular Movies This Week
                  const SizedBox(height: 10),
                  // Carrusel de películas
                  // Future significa que no lo va a hacer en el momento, lo puede resolver en el futuro, con una llamada http
                  // List<dynamic> representa los datos que va a devolver la API (una lista de objetos tipo mapa).
                  FutureBuilder<List<dynamic>>(
                    // dato asíncrono a esperar, la lista de películas
                    future: _popularMovies,
                    // Se llama cada vez que el estado de Future cambia
                    builder: (context, snapshot) {
                      // snapshot contiene el estado de future, connectionState muestra si está esperando, completado o falló.
                      // Si todavía no terminó la carga, muestra un icono y reserva el espacio
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        // mensaje de error si ocurrió uno al llamar la API
                        return Text(
                            'Error al cargar películas: ${snapshot.error}');
                      }
                      // snapshot.data! contiene la lista de películas
                      final movies = snapshot.data!;
                      final children = movies.map((movie) {
                        return MovieContainer(
                          movie: movie,
                          destination:
                              NewsDetailPage(), // Cambiá esto si querés ir a otra vista
                        );
                      }).toList();
                      return HorizontalCarousel(
                        controller: _scrollController,
                        scrollOffset: 800,
                        title: ' Popular Movies ',
                        children: children,
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                  // Frases en Hexágonos
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 200.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Column(
                          children: [
                            SizedBox(
                              width: 280.27,
                              height: 297.9,
                              child: PhraseHexagon(
                                  phrase: 'Explore the hive of entertainment'),
                            ),
                          ],
                        ),
                        SizedBox(width: 20), // Espacio entre hexágonos
                        Column(
                          children: [
                            SizedBox(
                              width: 280.27,
                              height: 297.9,
                              child: PhraseHexagon(
                                  phrase:
                                      'Be the voice behind the honey drops'),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            SizedBox(
                              width: 280.27,
                              height: 297.9,
                              child:
                                  PhraseHexagon(phrase: 'Be part of the hive'),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 70),
                  Text('THE BEST OF CINEMA, RATED BY YOU',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 81),
                            child: Text(
                              'Popular Reviews This Week',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 650,
                            child: Divider(
                              color: Color(0xFFF9F9F9),
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 30), // Separador entre ambos
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 81),
                            child: Text(
                              'Latest News',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          // Espacio entre título y línea
                          SizedBox(height: 5),
                          // Línea
                          SizedBox(
                            width: 450,
                            child: Divider(
                              color: Color(0xFFF9F9F9),
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 5),
                          SizedBox(
                            width: 680,
                            child: PopularMovieReviews(
                                scrollDirection: Axis.vertical),
                          ),
                        ],
                      ),
                      SizedBox(width: 30), // Separador entre ambos
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Espacio entre linea y latest news
                          SizedBox(height: 5),
                          // Línea
                          SizedBox(
                            width: 480,
                            child: LatestNews(scrollDirection: Axis.vertical),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Footer (logo + 2025 The Hive)
                  const Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
