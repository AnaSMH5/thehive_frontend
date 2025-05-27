import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> loginGetToken(String email, String password) async {
  final response = await http.post(
    Uri.parse('https://thehive-api.up.railway.app/api/v1/login/access-token'),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: {
      'username': email,
      'password': password,
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = json.decode(response.body);
    return data['access_token']; // devolver el acces token
  } else {
    final error = json.decode(response.body);
    throw Exception(error['detail'] ?? 'Unexpected error occurred');
  }
}