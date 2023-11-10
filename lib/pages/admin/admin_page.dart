import 'package:flutter/material.dart';
import 'package:jerupos/pages/admin/ingreso_diario.dart';
import 'package:jerupos/pages/admin/pedidos_page.dart';
import 'package:jerupos/pages/admin/stock_page.dart';
import 'package:jerupos/pages/admin/usuarios_page.dart';
import 'package:jerupos/widgets/usuario_drawer.dart';

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
              Tab(text: 'Pedidos'),
              Tab(text: 'Stock'),
              Tab(text: 'Usuarios'),
              Tab(text: 'Ingreso'),
            ],
          ),
        ),
        drawer: UsuarioDrawer(),
        body: TabBarView(
          children: [
            PedidosPage(),
            StockPage(),
            UsuariosPage(),
            IngresoDiario(),
          ],
        ),
      ),
    );
  }
}
