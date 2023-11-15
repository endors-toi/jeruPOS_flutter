import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jerupos/models/usuario.dart';
import 'package:jerupos/pages/admin/admin_page.dart';
import 'package:jerupos/pages/caja/caja_page.dart';
import 'package:jerupos/pages/cocina/cocina_page.dart';
import 'package:jerupos/pages/garzon/garzon_page.dart';
import 'package:jerupos/services/auth_service.dart';
import 'package:jerupos/utils/mostrar_snackbar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  final bool debug = true;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;

    return Scaffold(
      bottomNavigationBar: widget.debug
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(MdiIcons.shieldCrown),
                  label: 'Admin',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.kitchen),
                  label: 'Cocina',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Garzón',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.money_off),
                  label: 'Caja',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                  switch (index) {
                    case 0:
                      _emailCtrl.text = 'd@v.cl';
                      _passCtrl.text = 'sudosudo';
                      break;
                    case 1:
                      _emailCtrl.text = 'cocina@jerusalen.cl';
                      _passCtrl.text = 'mm';
                      break;
                    case 2:
                      _emailCtrl.text = 'garzon@jerusalen.cl';
                      _passCtrl.text = 'bv';
                      break;
                    case 3:
                      _emailCtrl.text = 'caja@jerusalen.cl';
                      _passCtrl.text = 'mm';
                      break;
                  }
                });
              },
            )
          : null,
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              flex: 2,
              child:
                  Container(child: Image.asset('assets/images/logo-min.png'))),
          Expanded(
              flex: 3,
              child: Form(
                key: _formKey,
                child: ListView(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Ingresa un email.';
                        }
                        if (email.contains('@') == false ||
                            email.contains('.') == false) {
                          return 'Ingresa un email válido.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _passCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contraseña',
                      ),
                      validator: (pass) {
                        if (pass == null || pass.isEmpty) {
                          return 'Ingresa una contraseña.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: _loading
                          ? ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey),
                              minimumSize:
                                  MaterialStateProperty.all(Size(0, 50)),
                              splashFactory: NoSplash.splashFactory,
                            )
                          : ButtonStyle(
                              elevation: MaterialStateProperty.all(18),
                              minimumSize:
                                  MaterialStateProperty.all(Size(0, 50)),
                            ),
                      onPressed: () {
                        if (_loading) return;
                        if (_formKey.currentState!.validate()) {
                          Login(context);
                          setState(() {
                            _loading = true;
                          });
                        }
                      },
                      child: Text(
                        'Log in',
                        style: _loading
                            ? TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(137, 73, 73, 73))
                            : TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  _loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(),
                ]),
              )),
        ]),
      ),
    );
  }

  Future<void> Login(BuildContext context) async {
    try {
      Map<String, dynamic> resp =
          await AuthService.login(_emailCtrl.text, _passCtrl.text)
              .timeout(Duration(seconds: 4));
      if (resp['detail'] != null) {
        final String? token = await AuthService.getAccessToken();
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
        } else {
          mostrarSnackbar(context, 'Error al iniciar sesión.');
          setState(() {
            _loading = false;
          });
        }
      }
    } catch (e) {
      if (e is TimeoutException) {
        mostrarSnackbar(context, 'Error de conexión.');
        setState(() {
          _loading = false;
        });
      } else {
        mostrarSnackbar(
            context, 'Error al iniciar sesión. Revisa tus credenciales.');
      }
    }
  }
}
