import 'package:http/http.dart' as http;
import 'package:jerupos/models/producto_pedido.dart';
import 'dart:convert';
import 'package:jerupos/services/network_service.dart';

class ProductoService {
  static final String url =
      'http://' + getServerIP() + '/api/restaurant/productos/';

  static Future<List<ProductoPedido>> list() async {
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map<ProductoPedido>((json) => ProductoPedido.fromJson(json))
          .toList();
    } else {
      print(response.statusCode);
      return [];
    }
  }

  static Future<ProductoPedido> get(int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar producto');
    }
  }
}
