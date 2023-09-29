import 'package:flutter/material.dart';
import 'package:jerupos/pages/admin/ingredientes/ingredientes_index_page.dart';
import 'package:jerupos/pages/admin/ingredientes/ingredientes_show_page.dart';
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
          backgroundColor: Colors.orange,
          title: Text('JeruPOS'),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black.withOpacity(0.5),
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
            IngredientesIndexPage(),
            StaffPage(),
          ],
        ),
      ),
    );
  }
}
