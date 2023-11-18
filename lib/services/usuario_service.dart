import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jerupos/models/usuario.dart';
import 'package:jerupos/services/network_service.dart';

class UsuarioService {
  static final url = 'http://' + getServerIP() + '/api/accounts/users/';

  static Future<List<Usuario>> list() async {
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Usuario> usuarios =
          body.map((dynamic item) => Usuario.fromJson(item)).toList();
      return usuarios;
    } else {
      print(response.statusCode);
      throw Exception('Failed to load users');
    }
  }

  static Future<String> create(Usuario usuario) async {
    final uri =
        Uri.parse('http://' + getServerIP() + '/api/accounts/register/');
    final response = await http.post(
      uri,
      headers: await getHeaders(),
      body: json.encode(usuario.toJson()),
    );

    if (response.statusCode != 201) {
      return response.body;
    }
    return "";
  }

  static Future<Usuario> get(int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar usuario');
    }
  }

  static Future<String> update(Map<String, dynamic> usuario, int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.put(
      uri,
      headers: await getHeaders(),
      body: json.encode(usuario),
    );

    if (response.statusCode != 200) {
      return response.body;
    }
    return "";
  }

  static Future<void> delete(int id) async {
    final uri = Uri.parse(url + '$id/');
    final response = await http.delete(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode != 204) {
      print(response.body);
      throw Exception('Error al eliminar usuario');
    }
  }
}
