import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final uri = Uri.parse(
      '${dotenv.env['API_URL_${dotenv.env['CURRENT_DEVICE']}']}/accounts/');

  static Future<void> login(String email, String password) async {
    final response = await http.post(
      uri.replace(path: '${uri.path}login/'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String token = data['access'];
      final String refreshToken = data['refresh'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('refresh_token', refreshToken);
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<void> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? refreshToken = prefs.getString('refresh_token');

    if (refreshToken != null) {
      final response = await http.post(
        uri.replace(path: '${uri.path}token/refresh/'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String newToken = data['access'];
        await prefs.setString('token', newToken);
      } else {
        throw Exception('Failed to refresh token');
      }
    }
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refresh_token');
  }
}
