import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jerupos/models/ajuste_stock.dart';
import 'package:jerupos/services/network_service.dart';

class StockService {
  static final String url =
      'http://' + getServerIP() + '/api/restaurant/ajuste-stock/';

  static Future<List<AjusteStock>> list() async {
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map<AjusteStock>((json) => AjusteStock.fromJson(json))
          .toList();
    } else {
      print(response.statusCode);
      return [];
    }
  }

  static Future<AjusteStock> get(int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return AjusteStock.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar ajuste de stock');
    }
  }

  static Future<void> create(AjusteStock ajusteStock) async {
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      headers: await getHeaders(),
      body: json.encode(ajusteStock.toJson()),
    );

    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Error al crear ajuste de stock');
    }
  }

  static Future<void> update(AjusteStock ajusteStock, int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.put(
      uri,
      headers: await getHeaders(),
      body: json.encode(ajusteStock.toJson()),
    );

    if (response.statusCode != 204) {
      print(response.body);
      throw Exception('Error al editar ajuste de stock');
    }
  }

  static Future<void> patch(Map<String, dynamic> ajusteStock, int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.patch(
      uri,
      headers: await getHeaders(),
      body: json.encode(ajusteStock),
    );

    if (response.statusCode != 204) {
      print(response.body);
      throw Exception('Error al modificar ajuste de stock');
    }
  }
}
