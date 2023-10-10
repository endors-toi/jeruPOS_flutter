import 'package:flutter/material.dart';
import 'package:jerupos/pages/admin/admin_page.dart';
import 'package:jerupos/pages/caja/caja_page.dart';
import 'package:jerupos/pages/cocina/cocina_page.dart';
import 'package:jerupos/pages/garzon/garzon_page.dart';
import 'package:jerupos/services/auth_service.dart';
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
              flex: 1,
              child:
                  Container(child: Image.asset('assets/images/logo-min.png'))),
          Expanded(
              flex: 2,
              child: ListView(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _passCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () async {
                      await Login(context);
                    },
                    child: Text('Login'),
                  ),
                ),
              ])),
        ]),
      ),
    );
  }

  Future<void> Login(BuildContext context) async {
    try {
      await AuthService.login(_emailCtrl.text, _passCtrl.text);
      final String? token = await AuthService.getToken();
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al iniciar sesión. Revisa tus credenciales.'),
        ),
      );
    }
  }
}
