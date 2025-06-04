import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/navigation_widget/nav_bar_controller.dart';
import 'package:frontend/widgets/movies_related_widgets/movie_container.dart';
import 'package:frontend/services/movies_service.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  bool? isLoggedIn;
  List<Map<String, dynamic>> _watchlistMovies = [];
  bool _isLoading = true;
  String? _error;
  String? _token;

  final String _baseUrl = 'https://thehive-api.up.railway.app/api/v1';

  final String _watchListName = "Watchlist";

  @override
  void initState() {
    super.initState();
    initTokenAndLoadData();
  }

  Future<void> initTokenAndLoadData() async {
    final loggedIn = await AuthService.isLoggedIn();
    setState(() {
      isLoggedIn = loggedIn;
    });

    if (!loggedIn) return;

    _token = await AuthService.getToken();

    if (!mounted) return;
    await _fetchWatchlistMovies();
  }

  Future<String?> _getListIdByName(String listName) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/lists/my-lists'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['movie_lists'] != null) {
        for (var list in data['movie_lists']) {
          if (list['name'] as String == listName) {
            return list['list_id'] as String?;
          }
        }
      }
      return null; // No se encontró la lista por nombre
    } else {
      setState(() {
        _error = 'Error al obtener ID de la lista: ${response.statusCode}';
      });
      return null;
    }
  }

  Future<void> _fetchWatchlistMovies() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final watchlistId = await _getListIdByName(_watchListName);

      if (watchlistId == null) {
        setState(() {
          _error = 'No se encontró la lista "$_watchListName".';
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/lists/$watchlistId'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final movieEntries = data['movies'] as List<dynamic>? ?? [];

        List<Map<String, dynamic>> moviesDetails = [];

        for (var movieData in movieEntries) {
          final movieIdString = movieData['movie_id'];
          if (movieIdString != null) {
            final movieId = int.tryParse(movieIdString.toString());
            if (movieId != null) {
              try {
                final movieDetail = await MovieService().getMovieDetails(movieId);
                moviesDetails.add({
                  'id': movieDetail.id,
                  'poster_path': movieDetail.posterUrl.replaceFirst('https://image.tmdb.org/t/p/w500', ''),
                  'vote_average': movieDetail.tmdbRating * 2,
                });
              } catch (e) {
                debugPrint('Error al obtener detalles de la película $movieId: $e');
              }
            } else {
              debugPrint('movie_id no es un número válido: $movieIdString');
            }
          }
        }


        if (mounted) {
          setState(() {
            _watchlistMovies = moviesDetails;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _error = 'Error al cargar la watchlist: ${response.statusCode}';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Ocurrió un error: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const NavBarController(),
            _buildBody(),
          ],
        )
      )
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            _error!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_watchlistMovies.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Center(
          child: Text(
            'Tu watchlist está vacía.',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ),
      );
    }

    // Envuelve en un SizedBox con altura estimada
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Scroll solo desde el padre
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 0.58,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
        ),
        itemCount: _watchlistMovies.length,
        itemBuilder: (context, index) {
          final movie = _watchlistMovies[index];
          return MovieContainer(
            movie: movie,
            iteration: index,
          );
        },
      ),
    );
  }
}