import 'package:flutter/material.dart';
import 'package:frontend/templates/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/widgets/register_form.dart';
import 'package:frontend/login_get_token.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  void _showRegisterDialog(BuildContext context) {
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
          backgroundColor: Theme.of(context).colorScheme.primary,  // Hacer el fondo del Dialog transparente
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Be Part of The Hive!',
                style: TextStyle(fontFamily: 'Aboreto',
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
                  tooltip: 'Close'
              ),
            ],
          ),
          content: RegisterForm(
            formKey: formKey,
            nameController: nameController,
            usernameController: usernameController,
            emailController: emailController,
            dateController: dateController,
            genderController: genderController,
            passwordController: passwordController,
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
                      Uri.parse('https://thehive.up.railway.app/api/v1/users/signup'),
                      headers: {"Content-Type": "application/json"},
                      body: json.encode(userData),
                    );

                    if (response.statusCode == 201 || response.statusCode == 200) {
                      // Obtener Bearer Token - Hacer Login
                      final token = await loginGetToken(emailController.text, passwordController.text);
                      // Crear Profile
                      final profileResponse = await http.post(
                        Uri.parse('https://thehive.up.railway.app/api/v1/profiles/'),
                        headers: {
                          'Content-Type': 'application/json',
                          'Authorization': 'Bearer $token',
                        },
                        body: json.encode({
                          'username': usernameController.text,
                          'description': '',
                          'profile_role': 'subscriber', // predeterminado
                          'image_rel_path' : '',
                        }),
                      );
                    // Verifica si el widget todavía está montado
                      if (!context.mounted) return;
                      if (profileResponse.statusCode == 201 || profileResponse.statusCode == 200){
                        // Registro y creación de profile exitosos
                        Navigator.of(context).pop();
                        // Redirige directamente sin mostrar mensajes
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()), // Cambiar pagina a homepage2
                        );
                      } else {
                        // Error al registrar
                        final errorProfile = json.decode(profileResponse.body);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'Failed to Create Profile',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            content: Text(
                              errorProfile['detail'] ?? 'Unexpected error occurred',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  'OK',
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                    } else {
                      // Error al registrar
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
                                  style: Theme.of(context).textTheme.labelMedium,
                              ),
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
        onPressed: () => _showRegisterDialog(context),
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