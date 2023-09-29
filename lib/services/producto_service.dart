import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductoService {
  static final uri = Uri.parse(
      '${dotenv.env['API_URL_${dotenv.env['CURRENT_DEVICE']}']}/productos');

  static Future<List<dynamic>> list() async {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      return [];
    }
  }

  static Future<void> create(Map<String, dynamic> producto) async {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(producto),
    );

    if (response.statusCode != 201) {
      print('status code: ${response.statusCode}');
      throw Exception('Error al crear producto');
    }
  }

  static Future<Map<String, dynamic>> get(int id) async {
    final response = await http.get(uri.replace(path: '${uri.path}/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar producto');
    }
  }

  static Future<void> update(Map<String, dynamic> producto, int id) async {
    final response = await http.put(
      uri.replace(path: '${uri.path}/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(producto),
    );

    if (response.statusCode != 204) {
      throw Exception('Error al editar producto');
    }
  }

  static Future<void> delete(int id) async {
    final response = await http.delete(uri.replace(path: '${uri.path}/$id'));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar producto');
    }
  }
}