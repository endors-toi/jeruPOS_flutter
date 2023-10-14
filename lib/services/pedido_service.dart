import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jerupos/services/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class PedidoService {
  static final uri = Uri.parse(
      '${dotenv.env['API_URL_${dotenv.env['CURRENT_DEVICE']}']}/restaurant/pedidos/');

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

  static Future<List<dynamic>> list() async {
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body)['detail']);
    } else {
      return json.decode(response.body);
    }
  }

  static Future<Map<String, dynamic>> create(
      Map<String, dynamic> pedido) async {
    final response = await http.post(
      uri,
      headers: await _getHeaders(),
      body: json.encode(pedido),
    );

    if (response.statusCode != 201) {
      Map<String, dynamic> error = {
        'status_code': response.statusCode,
        'message': json.decode(response.body)['detail'],
      };
      return error;
    } else {
      return json.decode(response.body);
    }
  }

  static Future<Map<String, dynamic>> get(int id) async {
    final response = await http.get(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      Map<String, dynamic> error = {
        'status_code': response.statusCode,
        'message': json.decode(response.body)['detail'],
      };
      return error;
    } else {
      return json.decode(response.body);
    }
  }

  static Future<Map<String, dynamic>> updatePUT(
      Map<String, dynamic> pedido, int id) async {
    final response = await http.put(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
      body: json.encode(pedido),
    );

    if (response.statusCode != 200) {
      Map<String, dynamic> error = {
        'status_code': response.statusCode,
        'message': json.decode(response.body)['detail'],
      };
      return error;
    } else {
      return json.decode(response.body);
    }
  }

  static Future<Map<String, dynamic>> updatePATCH(
      Map<String, dynamic> pedido) async {
    final response = await http.patch(
      uri.replace(path: '${uri.path}${pedido['id']}/'),
      headers: await _getHeaders(),
      body: json.encode(pedido),
    );

    if (response.statusCode != 200) {
      Map<String, dynamic> error = {
        'status_code': response.statusCode,
        'message': json.decode(response.body)['detail'],
      };
      return error;
    } else {
      return json.decode(response.body);
    }
  }

  static Future<Map<String, dynamic>> delete(int id) async {
    final response = await http.delete(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 204) {
      Map<String, dynamic> error = {
        'status_code': response.statusCode,
        'message': json.decode(response.body)['detail'],
      };
      return error;
    } else {
      return {'success': true};
    }
  }
}
