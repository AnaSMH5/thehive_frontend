import 'package:flutter/material.dart';
import 'package:frontend/widgets/latest_news_carrousel.dart';
import 'package:frontend/widgets/navigation_widget/nav_bar_controller.dart';
import 'package:frontend/widgets/footer.dart';
import 'package:frontend/widgets/horizontal_carousel.dart';
import 'package:frontend/services/movies_service.dart';
import 'package:frontend/widgets/movie_container.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ScrollController _scrollController1 = ScrollController();
  final MovieService _movieService = MovieService();
  late Future<List<dynamic>> _popularColombia;

  @override
  void initState() {
    super.initState();
    _popularColombia = _movieService.getPopularColombia();
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
                const LatestNewsCarrousel(),
                SizedBox(height: 50),
                FutureBuilder<List<dynamic>>(
                  future: _popularColombia,
                  // Se llama cada vez que el estado de Future cambia
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 300,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      // mensaje de error si ocurrió uno al llamar la API
                      return Text(
                          'Error al cargar películas populares en Colombia: ${snapshot.error}');
                    }
                    // snapshot.data! contiene la lista de películas
                    final movies = snapshot.data!;
                    final children = movies.map((movie) {
                      return MovieContainer(
                        movie: movie,
                        destination:
                            LoginPage(), // CAMBIAR PARA QUE VAYA A MOVIE DETAILS PAGE
                      );
                    }).toList();
                    return HorizontalCarousel(
                      controller: _scrollController1,
                      scrollOffset: MediaQuery.of(context).size.width * 0.8,
                      title: ' Top 10 Popular Movies This Year in Colombia ',
                      children: children,
                    );
                  },
                ),
                SizedBox(height: 50),
                const Footer()
              ],
            ),
          ),
        )
      ],
    ));
  }
}
