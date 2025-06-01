import 'package:flutter/material.dart';
import 'package:frontend/widgets/navigation_bar_in.dart';
import 'package:frontend/widgets/footer.dart';
import 'package:frontend/widgets/horizontal_carousel.dart';
import 'package:frontend/services/movies_service.dart';
import 'package:frontend/widgets/movie_container.dart';
import 'package:frontend/templates/login_page.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/navigation_bar.dart';
import 'package:frontend/widgets/movie_scroll.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  String? _token;
  final MovieService _movieService = MovieService();

  @override
  void initState() {
    super.initState();
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
            // Popular Movies in Colombia in The Year
            const MovieScroll(),
            const SizedBox(height: 50),
            // Trending Movies This Week
            FutureBuilder<List<dynamic>>(
              future: _movieService.getTrendingWeek(),
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
                  controller: ScrollController(),
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
              future: _movieService.getTopRated(),
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
                  controller: ScrollController(),
                  scrollOffset: MediaQuery.of(context).size.width * 0.7,
                  title: ' Top Rated Movies ',
                  children: children,
                );
              },
            ),
            const SizedBox(height: 50),
            // Popular Family Movies
            FutureBuilder<List<dynamic>>(
              future: _movieService.getFamily(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al cargar películas populares de familia: ${snapshot.error}');
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
                  controller: ScrollController(),
                  scrollOffset: MediaQuery.of(context).size.width * 0.7,
                  title: ' Family Movies ',
                  children: children,
                );
              },
            ),
            const SizedBox(height: 50),
            // Popular Aventura y Acción Movies
            FutureBuilder<List<dynamic>>(
              future: _movieService.getActionAdventure(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al cargar películas populares de romance: ${snapshot.error}');
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
                  controller: ScrollController(),
                  scrollOffset: MediaQuery.of(context).size.width * 0.7,
                  title: ' Action and Adventure Movies ',
                  children: children,
                );
              },
            ),
            const SizedBox(height: 50),
            // Popular Animated Movies
            FutureBuilder<List<dynamic>>(
              future: _movieService.getAnimated(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al cargar películas populares de romance: ${snapshot.error}');
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
                  controller: ScrollController(),
                  scrollOffset: MediaQuery.of(context).size.width * 0.7,
                  title: ' Animated Movies ',
                  children: children,
                );
              },
            ),
            const SizedBox(height: 50),
            // Popular Romance Movies
            FutureBuilder<List<dynamic>>(
              future: _movieService.getRomance(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al cargar películas populares de romance: ${snapshot.error}');
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
                  controller: ScrollController(),
                  scrollOffset: MediaQuery.of(context).size.width * 0.7,
                  title: ' Romance Movies ',
                  children: children,
                );
              },
            ),
            const SizedBox(height: 50),
            // Popular Fantasy Movies
            FutureBuilder<List<dynamic>>(
              future: _movieService.getFantasy(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al cargar películas populares de romance: ${snapshot.error}');
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
                  controller: ScrollController(),
                  scrollOffset: MediaQuery.of(context).size.width * 0.7,
                  title: ' Fantasy Movies ',
                  children: children,
                );
              },
            ),
            const SizedBox(height: 50),
            // Popular Horror Movies
            FutureBuilder<List<dynamic>>(
              future: _movieService.getHorror(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al cargar películas populares de romance: ${snapshot.error}');
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
                  controller: ScrollController(),
                  scrollOffset: MediaQuery.of(context).size.width * 0.7,
                  title: ' Horror Movies ',
                  children: children,
                );
              },
            ),
            const SizedBox(height: 50),
            // Popular Science Fiction Movies
            FutureBuilder<List<dynamic>>(
              future: _movieService.getScienceFiction(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al cargar películas populares de romance: ${snapshot.error}');
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
                  controller: ScrollController(),
                  scrollOffset: MediaQuery.of(context).size.width * 0.7,
                  title: 'Science Fiction Movies ',
                  children: children,
                );
              },
            ),
            const SizedBox(height: 50),
            // Popular Drama Movies
            FutureBuilder<List<dynamic>>(
              future: _movieService.getDrama(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al cargar películas populares de romance: ${snapshot.error}');
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
                  controller: ScrollController(),
                  scrollOffset: MediaQuery.of(context).size.width * 0.7,
                  title: ' Drama Movies ',
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
