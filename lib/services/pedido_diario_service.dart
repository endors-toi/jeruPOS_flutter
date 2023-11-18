import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jerupos/models/item_pedido.dart';
import 'package:jerupos/services/network_service.dart';

class PedidoDiarioService {
  static final String url =
      'http://' + getServerIP() + '/api/restaurant/pedido-diario/';

  static Future<List<ItemPedido>> list() async {
    final uri = Uri.parse(url);

    final response = await http.get(
      uri,
      headers: await getHeaders(),
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
    final uri = Uri.parse(url + '$id/');

    final response = await http.patch(
      uri,
      headers: await getHeaders(),
      body: json.encode(pedidoDiario),
    );

    if (response.statusCode != 204) {
      print(response.body);
    }
  }
}
