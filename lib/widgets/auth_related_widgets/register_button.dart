import 'package:flutter/material.dart';
import 'package:frontend/templates/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/widgets/auth_related_widgets/register_form.dart';
import 'package:frontend/services/auth_service.dart';

String _baseUrl = 'https://thehive-api.up.railway.app/api/v1';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  void showRegisterDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final dateController = TextEditingController();
    final genderController = TextEditingController();
    final passwordController = TextEditingController();
    final usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Be Part of The Hive!',
                style: TextStyle(
                  fontFamily: 'Aboreto',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF351904),
                ),
              ),
              IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF351904),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close'),
            ],
          ),
          content: SizedBox(
            height: 480, // Altura fija para el contenido
            child: SingleChildScrollView(
              child: RegisterForm(
                formKey: formKey,
                nameController: nameController,
                usernameController: usernameController,
                emailController: emailController,
                dateController: dateController,
                genderController: genderController,
                passwordController: passwordController,
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: 342,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: Text(
                  'Register',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final userData = {
                      "full_name": nameController.text,
                      "email": emailController.text,
                      "birth_date": dateController.text,
                      "user_gender": genderController.text,
                      "password": passwordController.text,
                    };
                    // Crear Usuario
                    final response = await http.post(
                      Uri.parse(
                          '$_baseUrl/users/signup'),
                      headers: {"Content-Type": "application/json"},
                      body: json.encode(userData),
                    );

                    if (response.statusCode == 201 || response.statusCode == 200) {
                      // Obtener Bearer Token - Hacer Login
                      // Hacer login automáticamente
                      final loginError = await AuthService.login(
                          emailController.text, passwordController.text);

                      if (loginError == null) {
                        // Obtener token guardado
                        final token = await AuthService.getToken();
                        // Crear perfil
                        final profileResponse = await http.post(
                          Uri.parse('$_baseUrl/profiles/'),
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer $token',
                          },
                          body: json.encode({
                            'username': usernameController.text,
                            'description': '',
                            'profile_role': 'subscriber',
                            'image_rel_path': '',
                          }),
                        );

                        if (profileResponse.statusCode == 201 || profileResponse.statusCode == 200) {
                          // Crear listas automáticamente cuando se registra un usuario
                          Future<void> createDefaultList(String name) async {
                            final listResponse = await http.post(
                              Uri.parse('$_baseUrl/lists/'),
                              headers: {
                                'Authorization': 'Bearer $token',
                                'Content-Type': 'application/json',
                              },
                              body: json.encode({
                                'name': name,
                                'description': 'Lista automática de $name',
                                'privacy': true,
                              }),
                            );
                            if (listResponse.statusCode != 201 && listResponse.statusCode != 200) {
                              debugPrint('Error creando la lista $name: ${listResponse.body}');
                            }
                          }
                          // Crear listas de Me gusta y Watchlist
                          await createDefaultList('Me gusta');
                          await createDefaultList('Watchlist');
                          await createDefaultList('Vistas');

                          // Verifica si el widget todavía está montado
                          if (!context.mounted) return;
                          // Registro y creación de profile exitosos, cerrar popup de registro
                          Navigator.of(context).pop();
                          // Redirige directamente sin mostrar mensajes
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginPage()),
                          );
                        } else {
                          // Verifica si el widget todavía está montado
                          if (!context.mounted) return;
                          // Error al registrar
                          final errorProfile =
                              json.decode(profileResponse.body);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Failed to Create Profile',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              content: Text(
                                errorProfile['detail'] ??
                                    'Unexpected error occurred',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'OK',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        // Login falló
                        final error = json.decode(response.body);
                        // Verifica si el widget todavía está montado
                        if (!context.mounted) return;
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'Registration Failed',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            content: Text(
                              error['detail'] ?? 'Unexpected error occurred',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  'OK',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      final error = json.decode(response.body);
                      if (!context.mounted) return;
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Registration Failed'),
                          content: Text(error['detail'] ?? 'Unexpected error'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 399,
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () => showRegisterDialog(context),
        child: Text(
          'Register now!',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: const Color(0xFF351904)),
        ),
      ),
    );
  }
}
