import 'package:flutter/material.dart';
import 'package:jerupos/pages/admin/inventario_page.dart';
import 'package:jerupos/pages/admin/menu_page.dart';
import 'package:jerupos/pages/admin/ordenes_page.dart';
import 'package:jerupos/pages/admin/staff_page.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox.shrink(),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Ordenes'),
              Tab(text: 'Menu'),
              Tab(text: 'Inventory'),
              Tab(text: 'Staff'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrdenesPage(),
            MenuPage(),
            InventarioPage(),
            StaffPage(),
          ],
        ),
      ),
    );
  }
}
