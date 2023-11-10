import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jerupos/models/usuario.dart'; // Import your Usuario model
import 'package:jerupos/services/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UsuarioService {
  static final uri = Uri.parse(
      '${dotenv.env['API_URL_${dotenv.env['CURRENT_DEVICE']}']}/accounts/users/');

  static Future<String?> _getToken() async {
    String? token = await AuthService.getAccessToken();

    if (token != null && JwtDecoder.isExpired(token)) {
      await AuthService.refreshToken();
      token = await AuthService.getAccessToken();
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

  static Future<List<Usuario>> list() async {
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Usuario.fromJson(json)).toList();
    } else {
      print(response.statusCode);
      throw Exception('Failed to load users');
    }
  }

  static Future<String> create(Usuario usuario) async {
    final response = await http.post(
      Uri.parse(
          '${dotenv.env['API_URL_${dotenv.env['CURRENT_DEVICE']}']}/accounts/register/'),
      headers: await _getHeaders(),
      body: json.encode(usuario.toJson()),
    );

    if (response.statusCode != 201) {
      return response.body;
    }
    return "";
  }

  static Future<Usuario> get(int id) async {
    final response = await http.get(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar usuario');
    }
  }

  static Future<String> update(Map<String, dynamic> usuario, int id) async {
    final response = await http.put(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
      body: json.encode(usuario),
    );

    if (response.statusCode != 200) {
      return response.body;
    }
    return "";
  }

  static Future<void> delete(int id) async {
    final response = await http.delete(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 204) {
      print(response.body);
      throw Exception('Error al eliminar usuario');
    }
  }

  static Future<Usuario> obtenerUsuario() async {
    final String? token = await AuthService.getAccessToken();
    if (token != null) {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      Usuario usuario = Usuario(
          id: decodedToken['user_id'],
          rol: decodedToken['rol'],
          nombre: decodedToken['nombre'],
          apellido: decodedToken['apellido'],
          email: decodedToken['email']);
      return usuario;
    }
    throw Exception('Token is null');
  }
}
