import 'package:flutter/material.dart';
import 'package:frontend/templates/home_page.dart';
import 'package:frontend/templates/login_page.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/templates/profile_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.getToken()
          .then((token) => token != null && token.isNotEmpty),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final loggedIn = snapshot.data!;
        if (loggedIn) {
          return LoginPage(); // tu home con sesión
        } else {
          return HomePage(); // tu home sin sesión
        }
      },
    );
  }
}
