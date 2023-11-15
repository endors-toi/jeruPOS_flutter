import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jerupos/models/ingrediente.dart';
import 'package:jerupos/services/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class IngredienteService {
  static final uri = Uri.parse(
      '${dotenv.env['API_URL_${dotenv.env['CURRENT_DEVICE']}']}/restaurant/ingredientes/');

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

  static Future<List<Ingrediente>> list() async {
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map<Ingrediente>((json) => Ingrediente.fromJson(json))
          .toList();
    } else {
      print(response.statusCode);
      return [];
    }
  }

  static Future<Ingrediente> get(int id) async {
    final response = await http.get(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return Ingrediente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar ingrediente');
    }
  }

  static Future<void> create(Ingrediente ingrediente) async {
    final response = await http.post(uri,
        headers: await _getHeaders(), body: json.encode(ingrediente.toJson()));

    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Error al crear ingrediente');
    }
  }

  static Future<void> update(Ingrediente ingrediente, int id) async {
    final response = await http.put(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
      body: json.encode(ingrediente.toJson()),
    );

    if (response.statusCode != 204) {
      print(response.body);
      throw Exception('Error al editar ingrediente');
    }
  }

  static Future<void> patch(Map<String, dynamic> ingrediente, int id) async {
    final response = await http.patch(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
      body: json.encode(ingrediente),
    );

    if (response.statusCode != 204) {
      print(response.body);
    }
  }

  static Future<void> delete(int id) async {
    final response = await http.delete(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 204) {
      print(response.body);
      throw Exception('Error al eliminar ingrediente');
    }
  }
}
