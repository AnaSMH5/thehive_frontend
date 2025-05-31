import 'package:flutter/material.dart';
import 'package:frontend/templates/login_page.dart';
import 'package:frontend/widgets/text_field.dart';
import 'package:frontend/services/auth_service.dart';

Future<void> showLoginPopUp(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final formKey = GlobalKey<FormState>();
      final emailController = TextEditingController();
      final passwordController = TextEditingController();

      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,  // Hacer el fondo del Dialog transparente
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Welcome Back!',
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
                const SizedBox(height: 25.0),
                CustomTextField(
                  controller: emailController,
                  textLabel: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  controller: passwordController,
                  textLabel: 'Password',
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 8 || value.length > 15) {
                      return 'Password must be between 8 and 15 characters';
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
                'Log In',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // Llamamos a login que devuelve String? errorMessage
                  final errorMessage = await AuthService.login(emailController.text, passwordController.text);

                  if (errorMessage == null) {
                    // Login exitoso
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()), // Cambiar pagina a homepage2
                    );
                  } else {
                    if (!context.mounted) return;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: SizedBox(
                          width: 220,
                          child: Text(
                            'Login failed: $errorMessage',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
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
