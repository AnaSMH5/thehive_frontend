import 'package:flutter/material.dart';
import 'package:frontend/widgets/text_field.dart';

class RegisterForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController dateController;
  final TextEditingController genderController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.dateController,
    required this.genderController,
    required this.passwordController,
    required this.usernameController,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: widget.nameController,
              textLabel: 'Full Name',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value){
                if (value == null || value.isEmpty || value.length < 3){
                  return 'A name is required (minimun 3 characters)';
                }
                // Verifica si contiene algún número
                if (RegExp(r'[0-9]').hasMatch(value)) {
                  return 'The name must not contain numbers';
                }
                // Verifica si contiene caracteres especiales
                if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
                  return 'Name must not contain special characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 25.0),
            CustomTextField(
              controller: widget.usernameController,
              textLabel: 'Username',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value){
                if (value == null || value.isEmpty || value.length < 3 || value.length >20){
                  return 'An username is required, must contain between 5 and 20 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 25.0),
            CustomTextField(
              controller: widget.emailController,
              textLabel: 'Email Address',
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value){
                if (value == null || value.isEmpty) {
                  return 'An email is required';
                }
                // Verifica que tenga el formato correcto: caracteres + @ + letrascorreo + .com/.net/.org/.co
                if (!RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Invalid email format';
                }
                return null;
              },
            ),
            const SizedBox(height: 25.0),
            CustomTextField(
                controller: widget.dateController,
                textLabel: 'Birth-Date (YYYY-MM-DD)',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A birth date is required';
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
              controller: widget.genderController,
              textLabel: 'Gender (male/female/other)',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value){
                if (value == null || value.isEmpty) {
                  return 'A gender is required';
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
              controller: widget.passwordController,
              textLabel: 'Password',
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value){
                if (value == null || value.isEmpty) {
                  return 'A password is required';
                }
                if (value.length < 8 || value.length > 15) {
                  return 'Password must be between 8 and 15 characters';
                }
                // Verifica si no contiene números
                if (!RegExp(r'[0-9]').hasMatch(value)) {
                  return 'Password must contain at least one number.';
                }
                // Verifica si no contiene caracteres especiales
                if (!RegExp(r"[!@#\$%^&*()_\-+=\[\]{}|\\:;\"'<>,.?/~`]').hasMatch(value)) {
                  return 'Password must contain at least a special character.';
                }
                // Verifica si no contiene una letra mayúscula
                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  return 'Password must contain at least one uppercase letter.';
                }
                // Verifica si no contiene una letra minúscula
                if (!RegExp(r'[a-z]').hasMatch(value)) {
                  return 'Password must contain at least one lowercase letter.';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
