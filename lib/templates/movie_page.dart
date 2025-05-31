import 'package:flutter/material.dart';
import 'package:frontend/widgets/navigation_bar_in.dart';

class MoviePage extends StatelessWidget {
  const MoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            children: [
              NavigationBarIn(),
              Text('MoviePage'),
            ],
          )
      ),
    );
  }
}
