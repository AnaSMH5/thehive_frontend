import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  // Definir como constante para evitar errores
  static const String _tokenKey = 'access_token';

  static Future<String?> login(String email, String password) async {
    // Realiza llamada HTTP para el login
    final response = await http.post(
      Uri.parse('https://thehive-api.up.railway.app/api/v1/login/access-token'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        'username': email,
        'password': password,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Decodifica la respuesta JSON
      final data = json.decode(response.body);
      // Extrae el access_token
      final token = data['access_token'];
      // Obtener la instancia
      final prefs = await SharedPreferences.getInstance();
      // Guarfar el token
      await prefs.setString(_tokenKey, token);
      return null;
    } else {
      try {
        final error = json.decode(response.body);
        return error['detail'] ?? error['message'] ?? error['error'] ?? 'Error inesperado';
      } catch (e) {
        return 'Error del servidor: código ${response.statusCode}';
      }
    }
  }

  // Obtener token para poderlos usar en otras páginas
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Salir de la página
  static Future<void> logout() async {
    // Obtiene la insstancia de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    // Elimina el token guardado
    await prefs.remove(_tokenKey);
  }

  static Future <String?> getUserId() async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) {
      return null;
    }

    final url = Uri.parse('https://thehive-api.up.railway.app/api/v1/users/account');

    final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Acceder al user_id
      return data['user_id'];
    } else {
      return null;
    }
  }
}
