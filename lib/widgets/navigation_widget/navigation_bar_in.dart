import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/widgets/root_page_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/widgets/navigation_widget/nav_text_button.dart';
import 'package:frontend/templates/login_page.dart';
import 'package:frontend/templates/movie_page.dart';
import 'package:frontend/services/auth_service.dart';

Future<String?> getImageRelPath() async {
  final token = await AuthService.getToken();
  final userId = await AuthService.getUserId();

  if (userId == null || userId.isEmpty) {
    debugPrint('Error: No se ha hecho Login');
    return null;
  }

  final String baseUrl = 'https://thehive-api.up.railway.app/api/v1/profiles';
  final url = Uri.parse('$baseUrl/$userId');

  final response = await http.get(
    url,
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // Acceder al campo 'image_rel_path'
    return data['image_rel_path'];
  } else {
    debugPrint('Error al obtener imagen de perfil: ${response.statusCode}');
    debugPrint('Cuerpo de la respuesta del error: ${response.body}');
    return null;
  }
}

class NavigationBarIn extends StatefulWidget implements PreferredSizeWidget {
  const NavigationBarIn({super.key});

  @override
  State<NavigationBarIn> createState() => _NavigationBarInState();

  @override
  Size get preferredSize => const Size.fromHeight(75.0);
}

class _NavigationBarInState extends State<NavigationBarIn> {
  late Future<String?> imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl =
        getImageRelPath(); // Llamar a la función async que obtendrá la URL
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 180, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        border: Border(
            bottom: BorderSide(
          color: theme.colorScheme.onPrimary,
          width: 2.0,
        )),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo y Nombre
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RootPage()),
              );
            },
            child: SvgPicture.asset(
              'assets/icons/logo+title.svg',
              height: 40,
            ),
          ),
          const Spacer(flex: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NavTextButton(
                label: 'HOME',
                destination: const RootPage(), // Use your main home/root page
              ),
              NavTextButton(
                label: 'FILMS',
                destination: const MoviePage(),
              ),
              NavTextButton(
                label: 'WATCHLIST',
                destination:
                    const LoginPage(), // Replace with your Watchlist page
              ),
              NavTextButton(
                label: 'NEWS',
                destination: const LoginPage(), // Replace with your News page
              ),
            ],
          ),
          const Spacer(),
          // Icono de búsqueda
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF351904)),
            iconSize: 28, // Tamaño del icono de búsqueda
            onPressed: () {
              // Acción al presionar búsqueda
              debugPrint(
                  'Search Tapped'); // CAMBIAR POR LA ACCION CORRECTA, MIENTRAS ESTA ESO PA SABER QUE SIRVE
            },
          ),
          const SizedBox(width: 12),
          // Icono de perfil
          FutureBuilder<String?>(
            future: imageUrl,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFFFECB8),
                    child: const CircularProgressIndicator(),
                  ),
                );
              } else {
                final imageUrl = snapshot.data;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      await AuthService.logout();
                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RootPage()),
                        );
                      }
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF50B2C0),
                      backgroundImage: imageUrl != null
                          ? NetworkImage(
                              'https://thehive-api.up.railway.app$imageUrl')
                          : null,
                      child: imageUrl == null
                          ? const Icon(Icons.person, color: Color(0xFFFFECB8))
                          : null,
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
