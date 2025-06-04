import 'package:flutter/material.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:frontend/widgets/utils/text_field.dart';

class UpdateForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController descriptionController;

  const UpdateForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.usernameController,
    required this.descriptionController,
  });

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  late Future<Map<String, String?>> hintsFuture;

  @override
  void initState() {
    super.initState();
    hintsFuture = getUpdateFormHints();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: hintsFuture,
      builder: (context, snapshot) {
        final hints = snapshot.data ?? {};
        return SingleChildScrollView(
          child: Form(
            key: widget.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: widget.nameController,
                  textLabel: 'Full Name',
                  hintText: hints['full_name'] ?? 'Enter your full name',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (value.length < 3) {
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
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15.0),
                CustomTextField(
                  controller: widget.usernameController,
                  textLabel: 'Username',
                  hintText: hints['username'] ?? 'Enter your username',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (value.length < 3 || value.length > 20) {
                        return 'An username is required, must contain between 5 and 20 characters';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15.0),
                CustomTextField(
                  controller: widget.descriptionController,
                  minLines: null,
                  maxLines: 5,
                  maxLength: 250,
                  textLabel: 'Description',
                  hintText: hints['description'] ??
                      'Write a short description about yourself',
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    // Your validation logic here
                    return null;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, String?>> getUpdateFormHints() async {
    final accountService = AccountService();
    final user = await accountService.getUserData();
    final profile = await accountService.getProfileData();

    return {
      'full_name': user?['full_name'] as String?,
      'username': profile?['username'] as String?,
      'description': profile?['description'] as String?,
    };
  }
}
