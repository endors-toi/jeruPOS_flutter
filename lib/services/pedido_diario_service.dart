import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jerupos/models/item_pedido.dart';
import 'package:jerupos/services/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class PedidoDiarioService {
  static final uri = Uri.parse(
      '${dotenv.env['API_URL_${dotenv.env['CURRENT_DEVICE']}']}/restaurant/pedido-diario/');

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

  static Future<List<ItemPedido>> list() async {
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map<ItemPedido>((json) => ItemPedido.fromJson(json))
          .toList();
    } else {
      print(response.statusCode);
      return [];
    }
  }

  static Future<void> patch(Map<String, dynamic> pedidoDiario, int id) async {
    final response = await http.patch(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
      body: json.encode(pedidoDiario),
    );

    if (response.statusCode != 204) {
      print(response.body);
    }
  }
}
