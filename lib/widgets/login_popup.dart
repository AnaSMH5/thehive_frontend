import 'package:flutter/material.dart';
import 'package:frontend/templates/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/widgets/text_field.dart';

class LoginPopup extends StatelessWidget {
  const LoginPopup({super.key});

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
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    controller: nameController,
                    textLabel: 'Full Name',
                    validator: (value){
                      if (value == null || value.isEmpty || value.length < 3){
                        return 'A name is required: minimun 3 characters';
                      }
                      // Verifica si contiene algún número
                      if (RegExp(r'[0-9]').hasMatch(value)) {
                        return 'The name must not contain numbers';
                      }
                      // Verificar que el nombre no contenga caracteres especiales
                      if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
                        return 'The name must not contain special characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25.0),
                  CustomTextField(
                    controller: usernameController,
                    textLabel: 'Username',
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Username is required';
                      }

                      if (value.length < 4 || value.length > 20){
                        return 'The username must have between 4 and 20 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25.0),
                  CustomTextField(
                    controller: emailController,
                    textLabel: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'An email is required';
                      }
                      // Verifica el formato, que contenga caracteres, luego un @ y el.com/.net/.org/.co
                      if (!RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25.0),
                  CustomTextField(
                      controller: dateController,
                      textLabel: 'Birth-Date (YYYY-MM-DD)',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Birth date is required';
                        }

                        final date = DateTime.tryParse(value);
                        // Si es nulo significa que no se convirtió correctamente, formato inválido
                        if (date == null) {
                          return 'Invalid format. Use YYYY-MM-DD';
                        }

                        final today = DateTime.now();
                        final thirteenYearsAgo = DateTime(today.year - 13, today.month, today.day);
                        // La fecha debe ser antes o igual a hoy menos 13 años
                        if (date.isAfter(thirteenYearsAgo)) {
                          return 'You must be at least 13 years old';
                        }

                        return null;
                      }
                  ),
                  const SizedBox(height: 25.0),
                  CustomTextField(
                    controller: genderController,
                    textLabel: 'Gender (male/female/other)',
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Gender is required';
                      }

                      final lower = value.toLowerCase();

                      if (lower != 'male' && lower != 'female' && lower != 'other') {
                        return 'Gender must be male, female or other. No spaces';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 25.0),
                  CustomTextField(
                    controller: passwordController,
                    textLabel: 'Password',
                    obscureText: true,
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                ],
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

                    final response = await http.post(
                      Uri.parse('https://thehive.up.railway.app/api/v1/users/signup'),
                      headers: {"Content-Type": "application/json"},
                      body: json.encode(userData),
                    );

                    if (response.statusCode == 201 || response.statusCode == 200) {
                      // Crear perfil
                      final profileData = {
                        "username": usernameController.text,
                        "description": "",
                        "profile_role": "subscriber",
                        "image_rel_path": ""
                      };

                      final profileResponse = await http.post(
                        Uri.parse('https://thehive.up.railway.app/api/v1/profiles/'),
                        headers: {"Content-Type": "application/json"},
                        body: json.encode(profileData),
                      );

                      if (response.statusCode == 201 || response.statusCode == 200){
                        // Verifica si el widget todavía está montado
                        if (!context.mounted) return;

                        // Registro exitoso y Creación de Perfil Exitoso
                        Navigator.of(context).pop();
                        // Redirige directamente sin mostrar mensajes
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()), // Cambia a tu página destino
                        );
                      } else {
                        final error = json.decode(profileResponse.body);
                        // Verifica si el widget todavía está montado
                        if (!context.mounted) return;
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'Profile Creation Failed',
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
