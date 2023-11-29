import 'package:http/http.dart' as http;
import 'package:jerupos/models/ingrediente.dart';
import 'package:jerupos/models/ingrediente_producto.dart';
import 'package:jerupos/models/producto.dart';
import 'package:jerupos/services/ingrediente_service.dart';
import 'dart:convert';
import 'package:jerupos/services/network_service.dart';

class ProductoService {
  static final String url =
      'http://' + getServerIP() + '/api/restaurant/productos/';

  static Future<List<Producto>> list() async {
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      List<Producto> productos = [];
      List<dynamic> data = json.decode(response.body);
      for (var prod in data) {
        Producto producto = Producto.fromJson(prod);
        List<IngredienteProducto> ingredientes = [];
        for (int id in prod['ingredientes']) {
          Ingrediente ing = await IngredienteService.get(id);
          IngredienteProducto ingrediente = IngredienteProducto(
            nombreIngrediente: ing.nombre,
            unidad: ing.unidad,
            cantidad: prod['cantidades'][prod['ingredientes'].indexOf(id)],
            ingrediente: ing.id!,
            producto: producto.id!,
          );
          ingredientes.add(ingrediente);
        }
        producto.ingredientes = ingredientes;
        productos.add(producto);
      }
      return productos;
    } else {
      print(response.statusCode);
      return [];
    }
  }

  static Future<Producto> get(int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      var prod = json.decode(response.body);
      Producto producto = Producto.fromJson(prod);
      List<IngredienteProducto> ingredientes = [];
      for (int id in prod['ingredientes']) {
        Ingrediente ing = await IngredienteService.get(id);
        IngredienteProducto ingrediente = IngredienteProducto(
          nombreIngrediente: ing.nombre,
          unidad: ing.unidad,
          cantidad: prod['cantidades'][prod['ingredientes'].indexOf(id)],
          ingrediente: ing.id!,
          producto: producto.id!,
        );
        ingredientes.add(ingrediente);
      }
      producto.ingredientes = ingredientes;
      return producto;
    } else {
      throw Exception('Error al cargar producto');
    }
  }

  static Future<Producto> create(Map<String, dynamic> producto) async {
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      headers: await getHeaders(),
      body: jsonEncode(producto),
    );

    if (response.statusCode == 201) {
      var data = json.decode(response.body);
      Producto producto = Producto.fromJson(data);
      return producto;
    } else {
      throw Exception('Error al crear producto\n' + response.body);
    }
  }

  static Future<Producto> update(Map<String, dynamic> producto, int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.put(
      uri,
      headers: await getHeaders(),
      body: jsonEncode(producto),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Producto producto = Producto.fromJson(data);
      return producto;
    } else {
      throw Exception('Error al actualizar producto\n' + response.body);
    }
  }

  static Future<void> delete(int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.delete(uri, headers: await getHeaders());

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar producto');
    }
  }
}
