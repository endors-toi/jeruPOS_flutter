import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/models/producto_pedido.dart';
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

  static Future<List<Pedido>> list() async {
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body)['error']);
    } else {
      List<Pedido> pedidos = [];
      List<dynamic> data = json.decode(response.body);
      for (var ped in data) {
        Pedido pedido = Pedido.fromJson(ped);
        pedido.productos = await getProductosPedido(pedido.id!);
        pedidos.add(pedido);
      }
      return pedidos;
    }
  }

  static Future<Map<String, dynamic>> create(Pedido pedido) async {
    final response = await http.post(
      uri.replace(path: '${uri.path}create_pedido_with_productos/'),
      headers: await _getHeaders(),
      body: json.encode(pedido.post()),
    );

    if (response.statusCode != 201) {
      print(response.body);
    }
    return json.decode(response.body);
  }

  static Future<Pedido> get(int id) async {
    final response = await http.get(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body)['error']);
    } else {
      Pedido pedido = Pedido.fromJson(json.decode(response.body));
      pedido.productos = await getProductosPedido(pedido.id!);
      return pedido;
    }
  }

  static Future<Pedido> updatePUT(Pedido pedido, int id) async {
    final response = await http.put(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
      body: json.encode(pedido.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body)['detail']);
    } else {
      return Pedido.fromJson(json.decode(response.body));
    }
  }

  static Future<Pedido> updatePATCH(Pedido pedido) async {
    final response = await http.patch(
      uri.replace(path: '${uri.path}${pedido.id}/'),
      headers: await _getHeaders(),
      body: json.encode(pedido),
    );

    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body)['detail']);
    } else {
      return Pedido.fromJson(json.decode(response.body));
    }
  }

  static Future<void> delete(int id) async {
    final response = await http.delete(
      uri.replace(path: '${uri.path}$id/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception(json.decode(response.body)['detail']);
    }
  }

  static Future<List<ProductoPedido>> getProductosPedido(int idPedido) async {
    final response = await http.get(
      Uri.parse(
          '${dotenv.env['API_URL_${dotenv.env['CURRENT_DEVICE']}']}/restaurant/pedidos-productos/?producto=&pedido=$idPedido'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<ProductoPedido> productosPedido = [];
      List<dynamic> data = json.decode(response.body);
      for (int i = 0; i < data.length; i++) {
        ProductoPedido prod = ProductoPedido(
          id: data[i]['producto']['id'],
          cantidad: data[i]['cantidad'],
          nombre: data[i]['producto']['nombre'],
          abreviacion: data[i]['producto']['abreviacion'],
          precio: data[i]['producto']['precio'],
        );
        productosPedido.add(prod);
      }
      return productosPedido;
    } else {
      throw Exception('Error al cargar productos del pedido');
    }
  }
}
