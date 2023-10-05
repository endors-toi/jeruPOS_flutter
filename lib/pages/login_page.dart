import 'package:flutter/material.dart';
import 'package:jerupos/pages/admin/admin_page.dart';
import 'package:jerupos/pages/caja/caja_page.dart';
import 'package:jerupos/pages/cocina/cocina_page.dart';
import 'package:jerupos/pages/garzon/comanda_page.dart';
import 'package:jerupos/services/auth_service.dart';
import 'package:jerupos/widgets/login_form.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  final bool debug = true;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _selectedIndex = 0;
  Widget body = LoginForm();

  @override
  void initState() {
    super.initState();
    if (widget.debug) {
      AuthService.login("d@v.cl", "sudosudo");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      body = AdminPage();
                      break;
                    case 1:
                      body = CocinaPage();
                      break;
                    case 2:
                      body = ComandaPage();
                      break;
                    case 3:
                      body = CajaPage();
                      break;
                  }
                });
              },
            )
          : null,
      body: body,
    );
  }
}
