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
}
