import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: 180,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos verticalmente
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: screenWidth, // Establece el ancho al ancho de la pantalla
              height: 80,
              child: SvgPicture.asset(
                'assets/icons/background_register.svg',
                fit: BoxFit.fitWidth,
                // No especificamos la altura para que se ajuste proporcionalmente
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 200, right: 200),
            child: Text(
              '© 2025 THE HIVE',
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}