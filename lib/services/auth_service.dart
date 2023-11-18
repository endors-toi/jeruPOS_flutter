import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:jerupos/services/network_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final String url = 'http://' + getServerIP() + '/api/accounts/';

  static Future<void> login(String email, String password) async {
    final uri = Uri.parse(url + 'login/');

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({'email': email, 'password': password}),
        )
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      String token = data['access'];
      String refreshToken = data['refresh'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('refresh_token', refreshToken);
    } else {
      throw Exception(json.decode(response.body)['detail']);
    }
  }

  static Future<bool> refreshToken() async {
    final uri = Uri.parse(url + 'token/refresh/');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? refreshToken = prefs.getString('refresh_token');
    if (refreshToken != null) {
      try {
        final response = await http.post(
          uri,
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

  static Future<void> logout() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refresh_token');
  }
}
