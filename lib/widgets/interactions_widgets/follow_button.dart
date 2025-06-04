import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:http/http.dart' as http;

class FollowButton extends StatefulWidget {
  final String profileId;
  final VoidCallback? onFollowed;

  const FollowButton({
    super.key,
    required this.profileId,
    this.onFollowed,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  late Future<Map<String, dynamic>?> profileData;

  @override
  void initState() {
    super.initState();
    profileData = AccountService().getProfileData();
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
        onPressed: () async {
          final token = await AuthService.getToken();

          if (token == null) {
            // Handle unauthenticated state
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please log in to follow')),
            );
            return;
          }

          // Create the follow request
          final response = await http.post(
              Uri.parse(
                  'https://thehive-api.up.railway.app/api/v1/follows/${widget.profileId}'),
              headers: {
                "Authorization": "Bearer $token",
              });

          if (response.statusCode == 200 || response.statusCode == 201) {
            if (widget.onFollowed != null) widget.onFollowed!();
          }

          if (response.statusCode != 200 && response.statusCode != 201) {
            final error = json.decode(response.body);
            if (!context.mounted) return;
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Failed Following'),
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
        },
        child: Text(
          'Follow',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: const Color(0xFF351904)),
        ),
      ),
    );
  }
}
