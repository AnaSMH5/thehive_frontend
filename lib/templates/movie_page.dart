import 'package:flutter/material.dart';
import 'package:frontend/widgets/navigation_widget/nav_bar_controller.dart';
import 'package:frontend/widgets/utils/footer.dart';
import 'package:frontend/widgets/movies_related_widgets/horizontal_carousel.dart';
import 'package:frontend/services/movies_service.dart';
import 'package:frontend/widgets/movies_related_widgets/movie_container.dart';
import 'package:frontend/templates/login_page.dart';
import 'package:frontend/widgets/movies_related_widgets/movie_scroll.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final MovieService _movieService = MovieService();
  bool _showContent = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Always reset _showContent to false when dependencies change
    _showContent = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const NavBarController(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const MovieScroll(),
                const SizedBox(height: 50),
                if (!_showContent)
                  // Show a spinner while waiting for the first frame
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 100),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  // Trending Movies This Week
                  FutureBuilder<List<dynamic>>(
                    future: _movieService.getTrendingWeek(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error al cargar películas trending esta semana: ${snapshot.error}');
                      }
                      final movies = snapshot.data!;
                      final children = movies.map((movie) {
                        return MovieContainer(
                          iteration: 1,
                          movie: movie,
                          destination: LoginPage(),
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
                  // Top Rated Movies
                  FutureBuilder<List<dynamic>>(
                    future: _movieService.getTopRated(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error al cargar películas mejor calificadas: ${snapshot.error}');
                      }
                      final movies = snapshot.data!;
                      final children = movies.map((movie) {
                        return MovieContainer(
                          iteration: 2,
                          movie: movie,
                          destination: LoginPage(),
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
                  // Family Movies
                  FutureBuilder<List<dynamic>>(
                    future: _movieService.getFamily(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error al cargar películas populares de familia: ${snapshot.error}');
                      }
                      final movies = snapshot.data!;
                      final children = movies.map((movie) {
                        return MovieContainer(
                          iteration: 3,
                          movie: movie,
                          destination: LoginPage(),
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
                  // Action and Adventure Movies
                  FutureBuilder<List<dynamic>>(
                    future: _movieService.getActionAdventure(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error al cargar películas populares de romance: ${snapshot.error}');
                      }
                      final movies = snapshot.data!;
                      final children = movies.map((movie) {
                        return MovieContainer(
                          iteration: 4,
                          movie: movie,
                          destination: LoginPage(),
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
                  // Animated Movies
                  FutureBuilder<List<dynamic>>(
                    future: _movieService.getAnimated(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error al cargar películas populares de romance: ${snapshot.error}');
                      }
                      final movies = snapshot.data!;
                      final children = movies.map((movie) {
                        return MovieContainer(
                          iteration: 5,
                          movie: movie,
                          destination: LoginPage(),
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
                  // Romance Movies
                  FutureBuilder<List<dynamic>>(
                    future: _movieService.getRomance(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error al cargar películas populares de romance: ${snapshot.error}');
                      }
                      final movies = snapshot.data!;
                      final children = movies.map((movie) {
                        return MovieContainer(
                          iteration: 6,
                          movie: movie,
                          destination: LoginPage(),
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
                  // Fantasy Movies
                  FutureBuilder<List<dynamic>>(
                    future: _movieService.getFantasy(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error al cargar películas populares de romance: ${snapshot.error}');
                      }
                      final movies = snapshot.data!;
                      final children = movies.map((movie) {
                        return MovieContainer(
                          iteration: 7,
                          movie: movie,
                          destination: LoginPage(),
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
                  // Horror Movies
                  FutureBuilder<List<dynamic>>(
                    future: _movieService.getHorror(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error al cargar películas populares de romance: ${snapshot.error}');
                      }
                      final movies = snapshot.data!;
                      final children = movies.map((movie) {
                        return MovieContainer(
                          iteration: 8,
                          movie: movie,
                          destination: LoginPage(),
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
                  // Science Fiction Movies
                  FutureBuilder<List<dynamic>>(
                    future: _movieService.getScienceFiction(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error al cargar películas populares de romance: ${snapshot.error}');
                      }
                      final movies = snapshot.data!;
                      final children = movies.map((movie) {
                        return MovieContainer(
                          iteration: 9,
                          movie: movie,
                          destination: LoginPage(),
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
                  // Drama Movies
                  FutureBuilder<List<dynamic>>(
                    future: _movieService.getDrama(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error al cargar películas populares de romance: ${snapshot.error}');
                      }
                      final movies = snapshot.data!;
                      final children = movies.map((movie) {
                        return MovieContainer(
                          iteration: 10,
                          movie: movie,
                          destination: LoginPage(),
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
              ],
            ),
          ),
        )
      ],
    ));
  }
}
