import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/widgets/nav_text_button.dart';
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
    imageUrl = getImageRelPath(); // Llamar a la función async que obtendrá la URL
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 10),

      decoration: ShapeDecoration(
        color: theme.colorScheme.primary,
        shape: const RoundedRectangleBorder(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo y Nombre
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()), // cambiar a home page 2
              );
            },
            child: SvgPicture.asset(
              'assets/icons/logo+title.svg',
              height: 40,
            ),
          ),
          const SizedBox(width: 29),
          NavTextButton (
              label: 'HOME',
              destination: const LoginPage() // Destinación a home page 2
          ),
          const SizedBox(width: 19),
          NavTextButton(
              label: 'FILMS',
              destination: const MoviePage()
          ),
          const SizedBox(width: 19),
          NavTextButton(
              label: 'WATCHLIST', width: 105,
              destination: const LoginPage() // Change the destination
          ),
          const SizedBox(width: 19),
          NavTextButton(
              label: 'NEWS',
              destination: const LoginPage() // Change the destination
          ),
          // Empujar iconos a la derecha
          const Spacer(),
          // Icono de búsqueda
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF351904)),
            iconSize: 28, // Tamaño del icono de búsqueda
            onPressed: () {
              // Acción al presionar búsqueda
              debugPrint('Search Tapped'); // CAMBIAR POR LA ACCION CORRECTA, MIENTRAS ESTA ESO PA SABER QUE SIRVE
            },
          ),
          const SizedBox(width: 12),
          // Icono de perfil
          FutureBuilder<String?>(
            future: imageUrl,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFFFECB8),
                  child: const CircularProgressIndicator(),
                );
              } else {
                final imageUrl = snapshot.data;
                return CircleAvatar(
                  radius: 20,
                  backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : null,
                  backgroundColor: const Color(0xFF50B2C0),
                  child: imageUrl == null || imageUrl.isEmpty
                      ? const Icon(Icons.person, size: 30, color: Color(0xFFF9F9F9))
                      : null,
                );
              }
            },
          )
        ],
      ),
    );
  }
}