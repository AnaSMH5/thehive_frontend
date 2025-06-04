import 'package:flutter/material.dart';
import 'package:frontend/widgets/auth_related_widgets/update_form.dart';
import 'package:frontend/widgets/image_picker_widget.dart';
import 'package:frontend/widgets/utils/edit_profile_pic.widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/services/auth_service.dart';

class EditProfileButton extends StatelessWidget {
  final String profilePicUrl;
  final VoidCallback? onProfileUpdated;

  const EditProfileButton(
      {super.key, required this.profilePicUrl, this.onProfileUpdated});

  void showUpdateDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final usernameController = TextEditingController();
    final descriptionController = TextEditingController();
    String? pickedImageUrl = profilePicUrl;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit Profile',
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
                tooltip: 'Close',
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HoverAvatar(
                  radius: 58,
                  imageUrl: pickedImageUrl,
                  onTap: () async {
                    final result = await showDialog<String>(
                      context: context,
                      builder: (context) => const WallpaperApp(),
                    );
                    if (result != null && result.isNotEmpty) {
                      setState(() {
                        pickedImageUrl = result;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                UpdateForm(
                  formKey: formKey,
                  nameController: nameController,
                  usernameController: usernameController,
                  descriptionController: descriptionController,
                ),
              ],
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
                  'Edit Profile',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                onPressed: () async {
                  final token = await AuthService.getToken();
                  if (formKey.currentState?.validate() ?? false) {
                    final userData = {
                      if (nameController.text.isNotEmpty)
                        'full_name': nameController.text,
                    };

                    // Update User
                    final response = await http.patch(
                      Uri.parse(
                          'https://thehive-api.up.railway.app/api/v1/users/account'),
                      headers: {
                        "Authorization": "Bearer $token",
                        "Content-Type": "application/json",
                      },
                      body: json.encode(userData),
                    );

                    if (response.statusCode != 200 &&
                        response.statusCode != 201) {
                      final error = json.decode(response.body);
                      if (!context.mounted) return;
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Edition Failed'),
                          content: Text(error['detail'] ?? 'Unexpected error'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    final profileData = {
                      if (usernameController.text.isNotEmpty)
                        'username': usernameController.text,
                      if (descriptionController.text.isNotEmpty)
                        'description': descriptionController.text,
                      if (pickedImageUrl != null)
                        'image_rel_path': pickedImageUrl,
                    };

                    // Update Profile
                    final profileResponse = await http.patch(
                      Uri.parse(
                          'https://thehive-api.up.railway.app/api/v1/profiles/update'),
                      headers: {
                        "Authorization": "Bearer $token",
                        "Content-Type": "application/json",
                      },
                      body: json.encode(profileData),
                    );

                    if (profileResponse.statusCode != 200 &&
                        profileResponse.statusCode != 201) {
                      final error = json.decode(profileResponse.body);
                      if (!context.mounted) return;
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Edition Failed'),
                          content: Text(error['detail'] ?? 'Unexpected error'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    // Optionally close the dialog on success
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      onProfileUpdated?.call();
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
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () => showUpdateDialog(
          context,
        ),
        child: Text(
          'Edit Profile',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: const Color(0xFF351904)),
        ),
      ),
    );
  }
}
