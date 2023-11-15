import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jerupos/models/usuario.dart';
import 'package:jerupos/pages/admin/admin_page.dart';
import 'package:jerupos/pages/caja/caja_page.dart';
import 'package:jerupos/pages/cocina/cocina_page.dart';
import 'package:jerupos/pages/garzon/garzon_page.dart';
import 'package:jerupos/services/auth_service.dart';
import 'package:jerupos/utils/mostrar_snackbar.dart';
import 'package:jerupos/widgets/login_form.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

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
      if (await AuthService.refreshToken().timeout(Duration(seconds: 1))) {
        final String? token =
            await AuthService.getAccessToken().timeout(Duration(seconds: 1));
        if (token != null) {
          final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          Usuario usuario = Usuario(
              id: decodedToken['user_id'],
              rol: decodedToken['rol'],
              nombre: decodedToken['nombre'],
              apellido: decodedToken['apellido'],
              email: decodedToken['email']);
          Provider.of<UsuarioProvider>(context, listen: false)
              .setUsuario(usuario);
          switch (usuario.rol) {
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
              mostrarSnackbar(context, 'No hay páginas asociadas a tu rol.');
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
        setState(() {
          body = LoginForm();
        });
      } else {
        mostrarSnackbar(context, 'Error desconocido.');
      }
    }
  }
}
