import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jerupos/services/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getServerIP() {
  switch (dotenv.env['CURRENT_DEVICE']) {
    case 'PHYS':
      return dotenv.env['PHYS_IP']!;
    case 'EMUL':
      return dotenv.env['EMUL_IP']!;
    case 'REMOTE':
      return dotenv.env['REMOTE_IP']!;
    default:
      return dotenv.env['API_URL_LOCAL']!;
  }
}

Future<String?> getAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<String?> getToken() async {
  String? token = await getAccessToken();

  if (token != null && JwtDecoder.isExpired(token)) {
    await AuthService.refreshToken();
    token = await getAccessToken();
  }

  return token;
}

Future<Map<String, String>> getHeaders() async {
  String? token = await getToken();
  return {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $token',
  };
}
