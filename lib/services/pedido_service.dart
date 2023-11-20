import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/models/producto_pedido.dart';
import 'package:jerupos/services/network_service.dart';

class PedidoService {
  static final String url =
      'http://' + getServerIP() + '/api/restaurant/pedidos/';

  static Future<List<Pedido>> list() async {
    final uri = Uri.parse(url);

    final response = await http.get(
      uri,
      headers: await getHeaders(),
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
    final uri = Uri.parse(url + 'create_pedido_with_productos/');
    final response = await http.post(
      uri,
      headers: await getHeaders(),
      body: json.encode(pedido.post()),
    );

    if (response.statusCode != 201) {
      print(response.body);
    }
    return json.decode(response.body);
  }

  static Future<Pedido> get(int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
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
    final uri = Uri.parse(url + '$id/');
    final response = await http.put(
      uri,
      headers: await getHeaders(),
      body: json.encode(pedido.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body));
    } else {
      return Pedido.fromJson(json.decode(response.body));
    }
  }

  static Future<Pedido> updatePATCH(Pedido pedido) async {
    final uri = Uri.parse(url + '${pedido.id}/');
    final response = await http.patch(
      uri,
      headers: await getHeaders(),
      body: json.encode(pedido.update()),
    );

    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body));
    } else {
      return Pedido.fromJson(json.decode(response.body));
    }
  }

  static Future<void> delete(int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.delete(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception(json.decode(response.body)['detail']);
    }
  }

  static Future<List<ProductoPedido>> getProductosPedido(int idPedido) async {
    final uri = Uri.parse('http://' +
        getServerIP() +
        '/api/restaurant/pedidos-productos/?producto=&pedido=$idPedido');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
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
