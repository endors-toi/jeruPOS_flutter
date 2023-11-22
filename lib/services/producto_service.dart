import 'package:http/http.dart' as http;
import 'package:jerupos/models/ingrediente.dart';
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
        List<Ingrediente> ingredientes = [];
        var ingredientesIds = prod['ingredientes'];
        for (var ingredienteId in ingredientesIds) {
          Ingrediente ingrediente = await IngredienteService.get(ingredienteId);
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
      var data = json.decode(response.body);
      var ingredientesIds = data['ingredientes'];
      Producto producto = Producto.fromJson(data);
      List<Ingrediente> ingredientes = [];
      for (var ingredienteId in ingredientesIds) {
        Ingrediente ingrediente = await IngredienteService.get(ingredienteId);
        ingredientes.add(ingrediente);
      }
      producto.ingredientes = ingredientes;
      return producto;
    } else {
      throw Exception('Error al cargar producto');
    }
  }
}
