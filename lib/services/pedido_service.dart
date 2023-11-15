import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jerupos/models/pedido.dart';
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
      throw Exception(json.decode(response.body)['detail']);
    } else {
      List<dynamic> jsonData = json.decode(response.body);

      // solución parche
      List<Map<String, dynamic>> adjustedJsonData =
          jsonData.map<Map<String, dynamic>>((pedidoJson) {
        List<Map<String, dynamic>> productos =
            List<Map<String, dynamic>>.from(pedidoJson['productos']);
        List<Map<String, dynamic>> adjustedProductos =
            productos.map((producto) {
          return {
            ...producto,
            'id': producto['producto'],
          };
        }).toList();
        return {
          ...pedidoJson,
          'productos': adjustedProductos,
        };
      }).toList();

      return adjustedJsonData
          .map<Pedido>((json) => Pedido.fromJson(json))
          .toList();
    }
  }

  static Future<Map<String, dynamic>> create(Pedido pedido) async {
    // solución parche, debería poder el modelo hacer esto
    List<Map<String, dynamic>> productos = pedido.productos.map((producto) {
      return {
        'producto': producto.id,
        'cantidad': producto.cantidad,
      };
    }).toList();
    Map<String, dynamic> ped = {
      'usuario': pedido.idUsuario,
      'mesa': pedido.mesa,
      'productos': productos,
      'estado': pedido.estado,
    };
    final response = await http.post(
      uri.replace(path: '${uri.path}create_pedido_with_productos/'),
      headers: await _getHeaders(),
      body: json.encode(ped),
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
      throw Exception(json.decode(response.body)['detail']);
    } else {
      // solución temporal
      Map<String, dynamic> jsonData = json.decode(response.body);
      var productosPost = jsonData['productos'];
      List<Map<String, dynamic>> adjustedProductos = [];
      if (productosPost != null) {
        List<Map<String, dynamic>> productos =
            List<Map<String, dynamic>>.from(productosPost);
        adjustedProductos = productos.map((producto) {
          return {
            ...producto,
            'id': producto['producto'],
          };
        }).toList();
      }
      Map<String, dynamic> adjustedJsonData = {
        ...jsonData,
        'productos': adjustedProductos,
      };

      return Pedido.fromJson(adjustedJsonData);
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

  static Future<Pedido> update(Pedido pedido) async {
    // solución temporal (no funciona XD)
    Map<String, dynamic> ped = {
      'id': pedido.id,
      'mesa': pedido.mesa,
      'productos_post':
          pedido.productos.map((producto) => producto.toJson()).toList(),
    };
    print(ped);
    final response = await http.patch(
      uri.replace(path: '${uri.path}${pedido.id}/'),
      headers: await _getHeaders(),
      body: json.encode(ped),
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
}
