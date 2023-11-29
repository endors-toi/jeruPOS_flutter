import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jerupos/services/network_service.dart';

class CategoriaService {
  static final String url =
      'http://' + getServerIP() + '/api/restaurant/categorias/';

  static Future<List<dynamic>> list() async {
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      return [];
    }
  }

  static Future<Map<String, dynamic>> get(int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar categoria');
    }
  }

  static Future<void> create(Map<String, dynamic> categoria) async {
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      headers: await getHeaders(),
      body: json.encode(categoria),
    );

    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Error al crear categoria');
    }
  }

  static Future<void> update(Map<String, dynamic> categoria, int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.put(
      uri,
      headers: await getHeaders(),
      body: json.encode(categoria),
    );

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Error al actualizar categoria');
    }
  }

  static Future<void> delete(int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.delete(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode != 204) {
      print(response.body);
      throw Exception('Error al eliminar categoria');
    }
  }
}
