import 'package:flutter/material.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/root_page_controller.dart';
//import 'package:frontend/widgets/movie_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Hive',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0F110C),
          colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFFECB8), // Peach - Color principal
              secondary: Color(0xFF50B2C0), // Moonstone - Color de acento
              surface:
                  Color(0xFFECA204), // Harvest Gold - Para fondos secundarios
              error: Color(0xFFECA204), // Harvest Gold - Error
              onPrimary:
                  Color(0xFF351904), // Bistre - Texto sobre colores primarios
              onSecondary:
                  Color(0xFF351904), // Bistre - Texto sobre colores secundarios
              onSurface: Color(0xFFF9F9F9), // Seasalt - Sobre el fondo
              onError: Color(0xFF0F110C), // Night sobre errores
              brightness: Brightness.dark),
          textTheme: AppTextTheme.textTheme),
      home: RootPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
