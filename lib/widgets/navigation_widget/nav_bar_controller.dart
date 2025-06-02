import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/navigation_widget/navigation_bar.dart';
import 'package:frontend/widgets/navigation_widget/navigation_bar_in.dart';

class NavBarController extends StatelessWidget {
  const NavBarController({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.getToken()
          .then((token) => token != null && token.isNotEmpty),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error al verificar sesión'));
        }
        if (!snapshot.hasData) {
          return const Center(
              child: Text('No se pudo determinar el estado de sesión'));
        }
        final loggedIn = snapshot.data!;
        if (loggedIn) {
          return NavigationBarIn(); // tu home con sesión
        } else {
          return CustomNavigationBar(); // tu home sin sesión
        }
      },
    );
  }
}
