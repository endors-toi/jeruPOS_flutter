import 'package:flutter/material.dart';
import 'package:jerupos/pages/admin/admin_page.dart';
import 'package:jerupos/pages/caja/caja_page.dart';
import 'package:jerupos/pages/cocina/cocina_page.dart';
import 'package:jerupos/pages/garzon/garzon_page.dart';
import 'package:jerupos/services/auth_service.dart';
import 'package:jerupos/utils/mostrar_snackbar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginForm extends StatefulWidget {
  final bool debug = true;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              flex: 4,
              child:
                  Container(child: Image.asset('assets/images/logo-min.png'))),
          Expanded(
              flex: 5,
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
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(18),
                        minimumSize: MaterialStateProperty.all(Size(0, 50)),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await Login(context);
                        }
                      },
                      child: Text(
                        'Log in',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ]),
              )),
        ]),
      ),
    );
  }

  Future<void> Login(BuildContext context) async {
    try {
      await AuthService.login(_emailCtrl.text, _passCtrl.text);
      final String? token = await AuthService.getAccessToken();
      if (token != null) {
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        int rol = decodedToken['rol'];
        switch (rol) {
          case 1:
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => GarzonPage()));
            break;
          case 2:
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => CocinaPage()));
            break;
          case 3:
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => CajaPage()));
            break;
          case 4:
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => AdminPage()));
            break;
          default:
            mostrarSnackBar(context, 'No hay páginas asociadas a tu rol.');
            break;
        }
      }
    } catch (e) {
      mostrarSnackBar(
          context, 'Error al iniciar sesión. Revisa tus credenciales.');
    }
  }
}
