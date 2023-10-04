import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jerupos/services/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UsuarioService {
  static final uri = Uri.parse(
      '${dotenv.env['API_URL_${dotenv.env['CURRENT_DEVICE']}']}/accounts/users/');

  static Future<String?> _getToken() async {
    String? token = await AuthService.getToken();

    if (token != null && JwtDecoder.isExpired(token)) {
      await AuthService.refreshToken();
      token = await AuthService.getToken();
    }

    return token;
  }

  static Future<Map<String, String>> _getHeaders() async {
    String? token = await _getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<List<dynamic>> list() async {
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      return [];
    }
  }

  static Future<void> create(Map<String, dynamic> usuario) async {
    final response = await http.post(
      uri,
      headers: await _getHeaders(),
      body: json.encode(usuario),
    );

    if (response.statusCode != 201) {
      print('status code: ${response.statusCode}');
      throw Exception('Error al crear usuario');
    }
  }

  static Future<Map<String, dynamic>> get(int id) async {
    final response = await http.get(
      uri.replace(path: '${uri.path}/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar usuario');
    }
  }

  static Future<void> update(Map<String, dynamic> usuario, int id) async {
    final response = await http.put(
      uri.replace(path: '${uri.path}/$id'),
      headers: await _getHeaders(),
      body: json.encode(usuario),
    );

    if (response.statusCode != 204) {
      print(response.body);
      throw Exception('Error al editar usuario');
    }
  }

  static Future<void> delete(int id) async {
    final response = await http.delete(
      uri.replace(path: '${uri.path}/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Error al eliminar usuario');
    }
  }
}
