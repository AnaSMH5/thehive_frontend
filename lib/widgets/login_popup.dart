import 'package:flutter/material.dart';
import 'package:frontend/templates/login_page.dart';
import 'package:frontend/widgets/text_field.dart';
import 'package:frontend/login_get_token.dart';

Future<void> showLoginPopUp(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
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
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 8) {
                      return 'Password must have at least 8 characters long';
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
                  final token = await loginGetToken(emailController.text, passwordController.text);

                  if (token.isNotEmpty){
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()), // Cambiar pagina a homepage2
                    );
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login failed. Please try again.')),
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
