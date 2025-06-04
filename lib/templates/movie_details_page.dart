import 'package:flutter/material.dart';
import 'package:frontend/widgets/navigation_widget/nav_bar_controller.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:frontend/widgets/movies_related_widgets/movie_info_section.dart';
import 'package:frontend/widgets/movies_related_widgets/movie_content_section.dart';
import 'package:frontend/widgets/utils/footer.dart';
import 'package:frontend/services/movies_service.dart';
import 'package:frontend/services/movie.dart';
import 'package:frontend/widgets/movies_related_widgets/horizontal_carousel.dart';
import 'package:frontend/widgets/movies_related_widgets/movie_container.dart';

enum CrewCastTab { crew, cast }

class MovieDetailsPage extends StatefulWidget {
  final int movieId;

  const MovieDetailsPage({
    super.key,
    required this.movieId,

  });

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage>{
  late Future<Movie> movie;
  CrewCastTab _selectedTab = CrewCastTab.crew;
  bool _showFullCrew = false;
  bool _showFullCast = false;

  @override
  void initState() {
    super.initState();
    movie = MovieService().getMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Movie>(
        future: movie,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final movie = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                const NavBarController(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 95),
                  child: Column(
                    children: [
                      // Trailer
                      SizedBox(
                        height: 604.69,
                        child: AspectRatio(
                          aspectRatio: 16 / 9, // proporción típica de video
                          child: (movie.trailerId != "") ? YoutubePlayer(
                            controller: YoutubePlayerController.fromVideoId(
                              videoId: movie.trailerId,
                              autoPlay: false,
                              params: const YoutubePlayerParams(
                                showControls: true,
                                showFullscreenButton: true,
                              ),
                            ),
                          )
                              : Image.network(
                            "https://image.tmdb.org/t/p/w500${movie.backDropPath}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.loose,
                            child: MovieContentSection(movie: movie),
                          ),
                          const SizedBox(width: 13.0),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: MovieInfoSection(movie: movie),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: _buildWhereToWatchSection(movie),
                          ),
                          const SizedBox(width: 13.0),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _buildTabButton('Crew', CrewCastTab.crew),
                                    const SizedBox(width: 20.0),
                                    _buildTabButton('Cast', CrewCastTab.cast),
                                  ],
                                ),
                                Divider(
                                  color: Color(0xFFF9F9F9),
                                  thickness: 2,
                                ),
                                const SizedBox(height: 12.0),
                                if (_selectedTab == CrewCastTab.crew)
                                  _buildCrewList(
                                      List<Map<String, dynamic>>.from(
                                          movie.crew))
                                else
                                  _buildCastList(
                                      List<Map<String, dynamic>>.from(
                                          movie.cast)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      // Recommended
                      // Verifica si hay recomendaciones y si están disponibles
                      if (movie.recommendations.isNotEmpty)
                        HorizontalCarousel(
                          controller: ScrollController(),
                          scrollOffset: MediaQuery.of(context).size.width * 0.7,
                          title: 'Recommendations',
                          children: movie.recommendations.map((recommendedMovie) {
                            return MovieContainer(
                              iteration: 1,  // Ajusta este valor según lo necesites
                              movie: recommendedMovie,  // Pasa el objeto Movie de la recomendación
                            );
                          }).toList(),
                        ),
                      // Si no hay recomendaciones, muestra un SizedBox vacío
                      if (movie.recommendations.isEmpty) const SizedBox(),
                    ],
                  ),
                ),
                const Footer(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWhereToWatchSection(Movie movie) {
    final providers = movie.watchProviders['CO'];
    if (providers == null || providers is! Map<String, dynamic>) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' Where to Watch',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12.0),
            Container(
              width: double.infinity,
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFF9F9F9).withValues(alpha: 0.6),
                ),
                //color: Color(0xFF351904),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                "No available streaming providers.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ]
        )
      );
    }

    final flatrate = (providers['flatrate'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final rent = (providers['rent'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final buy = (providers['buy'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    // Crear una lista única de plataformas basadas en provider_id
    final Map<int, Map<String, dynamic>> combined = {};

    for (var item in [...flatrate, ...rent, ...buy]) {
      final id = item['provider_id'];
      if (!combined.containsKey(id)) {
        combined[id] = {
          'provider_name': item['provider_name'],
          'logo_path': item['logo_path'],
          'canPlay': flatrate.any((e) => e['provider_id'] == id),
          'canRent': rent.any((e) => e['provider_id'] == id),
          'canBuy': buy.any((e) => e['provider_id'] == id),
        };
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ' Where to Watch',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFF9F9F9).withValues(alpha: 0.6),
              ),
              //color: Color(0xFF351904),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: combined.values.map((platform) {
                return _buildStreamingPlatformRowFromMap(platform);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamingPlatformRowFromMap(Map<String, dynamic> platform) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Row(
        children: [
          // Logo del proveedor
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: Color(0xFFF9F9F9).withValues(alpha: 0.5)),
              image: DecorationImage(
                image: NetworkImage('https://image.tmdb.org/t/p/w92${platform['logo_path']}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
                platform['provider_name'],
                style: Theme.of(context).textTheme.bodySmall
            ),
          ),
          if (platform['canPlay'] == true)
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              child: Text('Play', style: Theme.of(context).textTheme.bodyLarge),
            ),
          if (platform['canPlay'] == true && platform['canRent'] == true)
            const SizedBox(width: 8.0),
          if (platform['canRent'] == true)
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              child: Text('Rent', style: Theme.of(context).textTheme.bodyLarge),
            ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, CrewCastTab tab) {
    final isSelected = _selectedTab == tab;
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedTab = tab;
        });
      },
      child: Text(
        label,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: isSelected ? Color(0xFFECA204) : Color(0xFFF9F9F9),
        ),
      ),
    );
  }

  Widget _buildCrewList(List<Map<String, dynamic>> crew) {
    // Agrupar por roles
    final Map<String, List<String>> grouped = {};
    for (var member in crew) {
      final role = member['job'];
      final name = member['name'];
      if (grouped.containsKey(role)) {
        grouped[role]!.add(name);
      } else {
        grouped[role] = [name];
      }
    }

    final entries = grouped.entries.toList();
    // Inicialmente solo se pueden ver tres roles del crew
    final visibleEntries = _showFullCrew ? entries : entries.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...visibleEntries.map((entry) {
          return _buildRolePersonItem(entry.key, entry.value.join(', '));
        }),
        if (entries.length > 3)
          TextButton(
            onPressed: () {
              setState(() {
                _showFullCrew = !_showFullCrew;
              });
            },
            child: Text(_showFullCrew ? 'Less...' : 'More...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const  Color(0xFFFFECB8),
                  fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _buildCastList(List<Map<String, dynamic>> cast) {
    final visibleCast = _showFullCast ? cast : cast.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...visibleCast.map((member) =>
            _buildRolePersonItem(member['name'], member['character'])),
        // Si hay más de 5 cast members
        if (cast.length > 5)
          TextButton(
            onPressed: () {
              setState(() {
                _showFullCast = !_showFullCast;
              });
            },
            child: Text(_showFullCast ? 'Less...' : 'More...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const  Color(0xFFFFECB8),
                  fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _buildRolePersonItem(String title, String names) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200.0,
            child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              names,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
