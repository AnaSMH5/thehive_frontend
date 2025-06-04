import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountService {
  Future<Map<String, dynamic>?> getUserData() async {
    final token = await AuthService.getToken();
    final userId = await AuthService.getUserId();

    if (userId == null || userId.isEmpty) {
      debugPrint('Error: No se ha hecho Login');
      return null;
    }

    final url =
        Uri.parse('https://thehive-api.up.railway.app/api/v1/users/account');

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      debugPrint('Error al obtener usuario: ${response.statusCode}');
      debugPrint('Cuerpo de la respuesta del error: ${response.body}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getProfileData({String? profileId}) async {
    final token = await AuthService.getToken();
    final userId = await AuthService.getUserId();

    if (userId == null || userId.isEmpty) {
      debugPrint('Error: No se ha hecho Login');
      return null;
    }

    final url = Uri.parse(
        'https://thehive-api.up.railway.app/api/v1/profiles/${profileId ?? 'my-profile'}');

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      debugPrint('Error al obtener perfil: ${response.statusCode}');
      debugPrint('Cuerpo de la respuesta del error: ${response.body}');
      final data = json.decode(response.body);
      return {
        ...{'status_code': response.statusCode},
        ...data['detail']
      };
    }
  }
}
