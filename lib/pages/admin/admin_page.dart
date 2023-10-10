import 'package:flutter/material.dart';
import 'package:jerupos/pages/admin/pedidos_page.dart';
import 'package:jerupos/pages/admin/usuarios_page.dart';
import 'package:jerupos/widgets/user_drawer.dart';

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
              Tab(text: 'Pedidos'),
              Tab(text: 'Usuarios'),
            ],
          ),
        ),
        drawer: UserDrawer(),
        body: TabBarView(
          children: [
            PedidosPage(),
            UsuariosPage(),
          ],
        ),
      ),
    );
  }
}
