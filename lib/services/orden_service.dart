import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OrdenService {
  static final uri = Uri.parse(
      '${dotenv.env['API_URL_${dotenv.env['CURRENT_DEVICE']}']}/ordenes');

  static Future<List<dynamic>> list() async {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      return [];
    }
  }

  static Future<void> create(Map<String, dynamic> orden) async {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(orden),
    );

    if (response.statusCode != 201) {
      print('status code: ${response.statusCode}');
      throw Exception('Error al crear orden');
    }
  }

  static Future<Map<String, dynamic>> get(int id) async {
    final response = await http.get(uri.replace(path: '${uri.path}/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar orden');
    }
  }

  static Future<void> update(Map<String, dynamic> orden, int id) async {
    final response = await http.put(
      uri.replace(path: '${uri.path}/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(orden),
    );

    if (response.statusCode != 204) {
      print(response.body);
      throw Exception('Error al editar orden');
    }
  }

  static Future<void> delete(int id) async {
    final response = await http.delete(uri.replace(path: '${uri.path}/$id'));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar orden');
    }
  }
}