import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jerupos/models/ajuste_stock.dart';
import 'package:jerupos/services/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class StockService {
  static final uri = Uri.parse(
      '${dotenv.env['API_URL_${dotenv.env['CURRENT_DEVICE']}']}/restaurant/ajuste-stock/');

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

  static Future<List<AjusteStock>> list() async {
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map<AjusteStock>((json) => AjusteStock.fromJson(json))
          .toList();
    } else {
      print(response.statusCode);
      return [];
    }
  }

  static Future<AjusteStock> get(int id) async {
    final response = await http.get(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return AjusteStock.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar ajuste de stock');
    }
  }

  static Future<void> create(AjusteStock ajusteStock) async {
    final response = await http.post(
      uri,
      headers: await _getHeaders(),
      body: json.encode(ajusteStock.toJson()),
    );

    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Error al crear ajuste de stock');
    }
  }

  static Future<void> update(AjusteStock ajusteStock, int id) async {
    final response = await http.put(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
      body: json.encode(ajusteStock.toJson()),
    );

    if (response.statusCode != 204) {
      print(response.body);
      throw Exception('Error al editar ajuste de stock');
    }
  }

  static Future<void> patch(Map<String, dynamic> ajusteStock, int id) async {
    final response = await http.patch(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
      body: json.encode(ajusteStock),
    );

    if (response.statusCode != 204) {
      print(response.body);
      throw Exception('Error al modificar ajuste de stock');
    }
  }
}
