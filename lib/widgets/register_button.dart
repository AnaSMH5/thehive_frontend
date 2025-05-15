import 'package:flutter/material.dart';
import 'package:frontend/templates/login_page.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
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
