import 'package:flutter/material.dart';
import 'package:frontend/widgets/movies_related_widgets/custom_rating_bar.dart';
import 'package:frontend/services/movie.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/widgets/auth_related_widgets/register_button.dart';

class MovieContentSection extends StatefulWidget {
  final Movie movie;

  const MovieContentSection({
    super.key,
    required this.movie,
  });

  @override
  State<MovieContentSection> createState() => _MovieContentSectionState();
}

class _MovieContentSectionState extends State<MovieContentSection> {
  late double rating;
  Map<String, Set<String>> userMovieLists =
      {}; // clave: nombre lista, valor: set de movie_ids
  Map<String, String> listNameToId = {}; // tener list_id y hacer patch
  bool? isLoggedIn; // null = cargando, true = loggeado, false = no loggeado
  String? _token;

  final String _baseUrl = 'https://thehive-api.up.railway.app/api/v1';

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
    await loadUserRating();
    await getListIds();
    await fetchUserLists();
  }

  Future<void> loadUserRating() async {
    if (!isLoggedIn!) return;

    final movieId = widget.movie.id.toString();

    final response = await http.get(
      Uri.parse('$_baseUrl/ratings/profile'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['ratings'] != null) {
        final ratings = data['ratings'] as List<dynamic>;

        final movieRating = ratings.firstWhere(
          (r) => r['movie_id'] == movieId,
          orElse: () => null,
        );

        setState(() {
          if (movieRating != null) {
            rating = (movieRating['rate'] as num).toDouble();
          } else {
            rating = 0.0;
          }
        });
      } else {
        // No hay ratings, ponemos 0
        setState(() {
          rating = 0.0;
        });
      }
    } else {
      debugPrint('No se pudo obtener el rating: ${response.statusCode}');
    }
  }

  Future<void> getListIds() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/lists/my-lists'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Map<String, String> nameToIdMap = {};

      for (var list in data['movie_lists']) {
        final name = list['name'] as String;
        final listId = list['list_id'] as String;

        nameToIdMap[name] = listId;
      }

      setState(() {
        listNameToId = nameToIdMap;
      });
    } else {
      if (!mounted) return;
      AlertDialog(
        content: SizedBox(
          width: 220,
          child: Text(
            'Error al cargar los ids',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }
  }

  Future<void> fetchUserLists() async {
    for (var entry in listNameToId.entries) {
      final listName = entry.key;
      final listId = entry.value;

      final response = await http.get(
        Uri.parse('$_baseUrl/lists/$listId'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final movieEntries = data['movies'] as List<dynamic>? ?? [];

        final movieIds =
            movieEntries.map((movie) => movie['movie_id'].toString()).toSet();

        setState(() {
          userMovieLists[listName] = movieIds;
        });
      } else {
        debugPrint(
            'Error al obtener lista $listName ($listId): ${response.statusCode}');
      }
    }
  }

  bool isMovieInList(String listName) {
    return userMovieLists[listName]?.contains(widget.movie.id.toString()) ??
        false;
  }

  Future<void> toggleMovieInList(String listName) async {
    debugPrint('Entró a toggleMovieInList con la lista: $listName');
    if (!isLoggedIn!) return;

    final listId = listNameToId[listName];
    if (listId == null) {
      debugPrint('No se encontró listId para la lista: $listName');
      return;
    }

    final movieId = widget.movie.id;
    final isInList = isMovieInList(listName);

    final url = isInList
        ? '$_baseUrl/lists/$listId/r/movie/$movieId'
        : '$_baseUrl/lists/$listId/a/movie/$movieId';

    debugPrint('URL que se va a usar: $url');

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    debugPrint('Status code PATCH: ${response.statusCode}');
    debugPrint('Body respuesta PATCH: ${response.body}');

    final body = json.decode(response.body);
    final message = body['message'] ?? '';

    if (message.contains('added')) {
      setState(() {
        userMovieLists[listName]?.add(movieId.toString());
      });
    } else if (message.contains('removed')) {
      setState(() {
        userMovieLists[listName]?.remove(movieId.toString());
      });
    } else {
      debugPrint('Acción no realizada: $message');
      // Puedes mostrar un AlertDialog si quieres
    }
  }

  Future<void> saveRating(double newRating) async {
    if (!isLoggedIn!) return;

    setState(() {
      rating = newRating;
    });

    final movieId = widget.movie.id.toString();
    final response = await http.post(
      Uri.parse('$_baseUrl/ratings/movie/$movieId'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'rate': newRating}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      if (!mounted) return;
      AlertDialog(
        content: SizedBox(
          width: 220,
          child: Text(
            'Error al modificar rating',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    return Column(
      mainAxisSize:
          MainAxisSize.min, // No ocupar más espacio vertical del necesario
      children: [
        // Póster
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            movie.posterUrl, // URL ejemplo
            height: 435,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 30.0),
        // Iconos de acción
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon("Vistas", Icons.visibility, Icons.visibility_outlined),
            _buildIcon("Me gusta", Icons.favorite, Icons.favorite_border),
            _buildIcon(
                "Watchlist", Icons.watch_later, Icons.watch_later_outlined),
            /*IconButton(icon: Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).colorScheme.onSurface,
              size: 40,
            ), onPressed: () {}),*/
          ],
        ),
        const SizedBox(height: 17.0),
        // Gotas (Estrellas)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: CustomRatingBar(
                initialRating: isLoggedIn! ? rating : 0.0,
                ignoreGestures:
                    !isLoggedIn!, // Logged in no puede ser null, si Logged In es true, ignore gestures is false
                itemSize: 40,
                onChanged: (newRating) {
                  saveRating(newRating); // Guarda el rating en la API
                  setState(() {
                    rating =
                        newRating; // Actualiza para reflejar el cambio al instante
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 22.0),
        // Escribe una reseña
        // ESTO DEBE SER UN DESTINO A UN POPUP DONDE PUEDAS COLOCAR TU REVIEW, O QUE TE LLEVE A LA PARTE DE LA PAGINA DONDE LA ESCRIBAS
        Text(
          'Write a Review',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Color(0xFFF9F9F9), decoration: TextDecoration.underline),
        ),
      ],
    );
  }

  Widget _buildIcon(
      String listName, IconData filledIcon, IconData outlineIcon) {
    final isInList = isMovieInList(listName);
    return IconButton(
      icon: Icon(
        // Si el usuario está logueado (! asegura que no es null)
        // Si está logueado, isInList es true, muestra ícono lleno
        // SIno muestra el ícono bordeado
        isLoggedIn! ? (isInList ? filledIcon : outlineIcon) : outlineIcon,
        color: Theme.of(context).colorScheme.onSecondary,
        size: 40,
      ),
      // Solo funciona si el usuario está logueado
      onPressed: () {
        if (isLoggedIn!) {
          toggleMovieInList(listName);
        } else {
          // Mostrar el diálogo de registro si no está logueado
          RegisterButton().showRegisterDialog(context);
        }
      },
    );
  }
}
