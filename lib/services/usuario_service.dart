import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jerupos/models/usuario.dart';

class UsuarioService {
  static Future<List<Usuario>> getUsuarios() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/usuarios'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> jsonUsuarios = data['usuarios'];
      List<Usuario> usuarios =
          jsonUsuarios.map((json) => Usuario.fromJson(json)).toList();
      return usuarios;
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }

  static Future<void> createUsuario(Usuario usuario) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/usuarios'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode != 201) {
      print('status code: ${response.statusCode}');
      throw Exception('Error al crear usuario');
    }
  }

  static Future<void> updateUsuario(Usuario usuario, int id) async {
    final response = await http.put(
      Uri.parse('${dotenv.env['API_URL']}/usuarios/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Error al editar usuario');
    }
  }

  static Future<void> deleteUsuario(int id) async {
    final response = await http.delete(
      Uri.parse('${dotenv.env['API_URL']}/usuarios/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar usuario');
    }
  }

  static Future<Usuario> getUsuario(int id) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/usuarios/$id'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      Usuario usuario = Usuario.fromJson(data['usuario']);
      return usuario;
    } else {
      throw Exception('Error al cargar usuario');
    }
  }
}
