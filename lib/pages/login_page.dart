import 'dart:async';

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
    try {
      if (await AuthService.refreshToken()) {
        final String? token =
            await AuthService.getAccessToken().timeout(Duration(seconds: 5));
        if (token != null) {
          final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          int rol = decodedToken['rol'];
          switch (rol) {
            case 1:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => GarzonPage()));
              break;
            case 2:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CocinaPage()));
              break;
            case 3:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => CajaPage()));
              break;
            case 4:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AdminPage()));
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
    } catch (e) {
      if (e is TimeoutException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo conectar con el servidor.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
      setState(() {
        body = LoginForm();
      });
    }
  }
}
