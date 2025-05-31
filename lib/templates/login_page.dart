import 'package:flutter/material.dart';
import 'package:frontend/widgets/navigation_bar_in.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            NavigationBarIn(),
            Text('Bienvenido a la página de login'),
          ],
        )
      ),
    );
  }
}
