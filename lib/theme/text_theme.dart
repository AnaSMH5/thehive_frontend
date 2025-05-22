import 'package:flutter/material.dart';

class AppTextTheme {
  static TextTheme get textTheme {
    return const TextTheme(
       // Main homepage phrase (Jost 50)
        displayLarge: TextStyle(fontFamily: 'Jost',
            fontSize: 45,
            fontWeight: FontWeight.w400,
            color: Color(0xFFF9F9F9)),
        // Second homepage phrase (Aboreto 40)
        displayMedium: TextStyle(
            fontFamily: 'Aboreto', fontSize: 40, color: Color(0xFFF9F9F9)),

        // Movie titles (Aboreto 30)
        headlineLarge: TextStyle(
            fontFamily: 'Aboreto', fontSize: 30, color: Color(0xFFF9F9F9)),
        // Section titles (Jost 30)
        headlineMedium: TextStyle(fontFamily: 'Jost',
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: Color(0xFFF9F9F9)),

        // Homepage registration phrases (Jost 24)
        titleLarge: TextStyle(fontFamily: 'Jost',
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Color(0xFFF9F9F9)),

        // Movie info and NavBar text (Jost 20)
        bodyLarge: TextStyle(
            fontFamily: 'Jost',
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color(0xFF351904)),
        // News names (Aboreto 20)
        bodyMedium: TextStyle(fontFamily: 'Aboreto',
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color(0xFFF9F9F9)),

        // Footer text (Aboreto 24)
        labelLarge: TextStyle(fontFamily: 'Aboreto',
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color(0xFFF9F9F9)),
        // username y likes
        labelMedium:TextStyle(fontFamily: 'Jost',
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Color(0xFFF9F9F9)) ,
        // News section name (Jost 12)
        labelSmall: TextStyle(fontFamily: 'Jost',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFFF9F9F9))

    );
  }
}
