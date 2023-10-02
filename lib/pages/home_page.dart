import 'package:flutter/material.dart';
import 'package:jerupos/pages/admin/admin_page.dart';
import 'package:jerupos/pages/caja/caja_page.dart';
import 'package:jerupos/pages/cocina/cocina_page.dart';
import 'package:jerupos/pages/garzon/comanda_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Widget destino = AdminPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: destino,
      bottomNavigationBar: BottomNavigationBar(
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
          _selectedIndex = index;
          switch (index) {
            case 0:
              destino = AdminPage();
              break;
            case 1:
              destino = CocinaPage();
              break;
            case 2:
              destino = ComandaPage();
              break;
            case 3:
              destino = CajaPage();
              break;
          }
          setState(() {});
        },
      ),
    );
  }
}
