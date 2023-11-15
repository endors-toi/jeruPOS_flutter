import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final uri = Uri.parse(
      '${dotenv.env['API_URL_${dotenv.env['CURRENT_DEVICE']}']}/accounts/');

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        uri.replace(path: '${uri.path}login/'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        String token = data['access'];
        String refreshToken = data['refresh'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('refresh_token', refreshToken);
      } else {
        Map<String, dynamic> resp = json.decode(response.body);
        return resp;
      }
    } catch (e) {
      if (e is TimeoutException) {
        print("Error de conexión.");
      }
    }
    return {};
  }

  static Future<bool> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? refreshToken = prefs.getString('refresh_token');

    if (refreshToken != null) {
      try {
        final response = await http.post(
          uri.replace(path: '${uri.path}token/refresh/'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({'refresh': refreshToken}),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final String newToken = data['access'];
          await prefs.setString('token', newToken);
          return true;
        } else {
          await prefs.remove('token');
          await prefs.remove('refresh_token');
        }
      } catch (e) {
        if (e is TimeoutException) {
          prefs.remove('token');
          prefs.remove('refresh_token');
        }
      }
    }
    return false;
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refresh_token');
  }
}
