import 'package:flutter/material.dart';
import 'package:frontend/widgets/navigation_bar_in.dart';
import 'package:frontend/widgets/footer.dart';
import 'package:frontend/widgets/horizontal_carousel.dart';
import 'package:frontend/services/movies_service.dart';
import 'package:frontend/widgets/movie_container.dart';
import 'package:frontend/templates/login_page.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/navigation_bar.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  String? _token;
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final ScrollController _scrollController3 = ScrollController();
  final MovieService _movieService = MovieService();
  late Future<List<dynamic>> _topRated;
  late Future<List<dynamic>> _popularColombia;
  late Future<List<dynamic>> _trendingWeek;

  @override
  void initState() {
    super.initState();
    _topRated = _movieService.getTopRated();
    _popularColombia = _movieService.getPopularColombia();
    _trendingWeek = _movieService.getTrendingWeek();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await AuthService.getToken();
    setState(() {
      _token = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_token != null)
              NavigationBarIn()
            else
              CustomNavigationBar(),
            const SizedBox(height: 50),
            // Upcoming Movies
            FutureBuilder<List<dynamic>>(
              future: _popularColombia,
              // Se llama cada vez que el estado de Future cambia
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) { // mensaje de error si ocurrió uno al llamar la API
                  return Text('Error al cargar películas populares en Colombia: ${snapshot.error}');
                }
                // snapshot.data! contiene la lista de películas
                final movies = snapshot.data!;
                final children = movies.map((movie) {
                  return MovieContainer(
                    movie: movie,
                    destination: LoginPage(), // CAMBIAR PARA QUE VAYA A MOVIE DETAILS PAGE
                  );
                }).toList();
                return HorizontalCarousel(
                  controller: _scrollController2,
                  scrollOffset: MediaQuery.of(context).size.width * 0.8,
                  title: ' Top 10 Popular Movies This Year in Colombia ',
                  children: children,
                );
              },
            ),
            const SizedBox(height: 50),
            // Trending Movies This Week
            FutureBuilder<List<dynamic>>(
              future: _trendingWeek,
              // Se llama cada vez que el estado de Future cambia
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) { // mensaje de error si ocurrió uno al llamar la API
                  return Text('Error al cargar películas trending esta semana: ${snapshot.error}');
                }
                // snapshot.data! contiene la lista de películas
                final movies = snapshot.data!;
                final children = movies.map((movie) {
                  return MovieContainer(
                    movie: movie,
                    destination: LoginPage(), // CAMBIAR PARA QUE VAYA A MOVIE DETAILS PAGE
                  );
                }).toList();
                return HorizontalCarousel(
                  controller: _scrollController3,
                  scrollOffset: MediaQuery.of(context).size.width * 0.7,
                  title: ' Trending Movies This Week ',
                  children: children,
                );
              },
            ),
            const SizedBox(height: 50),
            // Carrusel de películas con mejor ranking
            // Future significa que no lo va a hacer en el momento, lo puede resolver en el futuro, con una llamada http
            // List<dynamic> representa los datos que va a devolver la API (una lista de objetos tipo mapa).
            FutureBuilder<List<dynamic>>(
              // dato asíncrono a esperar, la lista de películas
              future: _topRated,
              // Se llama cada vez que el estado de Future cambia
              builder: (context, snapshot) {
                // snapshot contiene el estado de future, connectionState muestra si está esperando, completado o falló.
                // Si todavía no terminó la carga, muestra un icono y reserva el espacio
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) { // mensaje de error si ocurrió uno al llamar la API
                  return Text('Error al cargar películas mejor calificadas: ${snapshot.error}');
                }
                // snapshot.data! contiene la lista de películas
                final movies = snapshot.data!;
                final children = movies.map((movie) {
                  return MovieContainer(
                    movie: movie,
                    destination: LoginPage(), // CAMBIAR PARA QUE VAYA A MOVIE DETAILS PAGE
                  );
                }).toList();
                return HorizontalCarousel(
                  controller: _scrollController1,
                  scrollOffset: MediaQuery.of(context).size.width * 0.7,
                  title: ' Top Rated Movies ',
                  children: children,
                );
              },
            ),
            const SizedBox(height: 50),
            const Footer(),
          ],
        )
      ),
    );
  }
}
