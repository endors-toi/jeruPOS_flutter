import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jerupos/models/ingrediente.dart';
import 'package:jerupos/services/network_service.dart';

class IngredienteService {
  static final String url =
      'http://' + getServerIP() + '/api/restaurant/ingredientes/';

  static Future<List<Ingrediente>> list() async {
    final uri = Uri.parse(url);

    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map<Ingrediente>((json) => Ingrediente.fromJson(json))
          .toList();
    } else {
      print(response.statusCode);
      return [];
    }
  }

  static Future<Ingrediente> get(int id) async {
    final uri = Uri.parse(url + '$id/');

    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return Ingrediente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar ingrediente');
    }
  }

  static Future<void> create(Ingrediente ingrediente) async {
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      headers: await getHeaders(),
      body: json.encode(ingrediente.toJson()),
    );

    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Error al crear ingrediente');
    }
  }

  static Future<void> update(Ingrediente ingrediente, int id) async {
    final uri = Uri.parse(url + '$id/');

    final response = await http.put(
      uri,
      headers: await getHeaders(),
      body: json.encode(ingrediente.toJson()),
    );

    if (response.statusCode != 204) {
      print(response.body);
      throw Exception('Error al editar ingrediente');
    }
  }

  static Future<void> patch(Map<String, dynamic> ingrediente, int id) async {
    final uri = Uri.parse(url + '$id/');

    final response = await http.patch(
      uri,
      headers: await getHeaders(),
      body: json.encode(ingrediente),
    );

    if (response.statusCode != 204) {
      print(response.body);
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
      throw Exception('Error al eliminar ingrediente');
    }
  }
}
