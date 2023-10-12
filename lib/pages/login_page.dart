import 'package:flutter/material.dart';
import 'package:jerupos/pages/admin/admin_page.dart';
import 'package:jerupos/pages/caja/caja_page.dart';
import 'package:jerupos/pages/cocina/cocina_page.dart';
import 'package:jerupos/pages/garzon/garzon_page.dart';
import 'package:jerupos/services/auth_service.dart';
import 'package:jerupos/widgets/login_form.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget? body;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
    );
  }

  Future<void> _initAsync() async {
    if (await AuthService.refreshToken()) {
      final String? token = await AuthService.getAccessToken();
      if (token != null) {
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        int rol = decodedToken['rol'];
        switch (rol) {
          case 1:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => GarzonPage()));
            break;
          case 2:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CocinaPage()));
            break;
          case 3:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CajaPage()));
            break;
          case 4:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AdminPage()));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No hay páginas asociadas a tu rol.'),
              ),
            );
            break;
        }
      }
    } else {
      setState(() {
        body = LoginForm();
      });
    }
  }
}
