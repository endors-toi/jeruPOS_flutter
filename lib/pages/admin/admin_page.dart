import 'package:flutter/material.dart';
import 'package:jerupos/widgets/usuario_drawer.dart';

import 'package:jerupos/pages/admin/ingreso_diario.dart';
import 'package:jerupos/pages/admin/pedidos_page.dart';
import 'package:jerupos/pages/admin/productos_page.dart';
import 'package:jerupos/pages/admin/reporte_diario_page.dart';
import 'package:jerupos/pages/admin/ingredientes_page.dart';
import 'package:jerupos/pages/admin/usuarios_page.dart';

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
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
              Tab(text: 'Ingredientes'),
              Tab(text: 'Productos'),
              Tab(text: 'Usuarios'),
              Tab(text: 'Ingreso'),
              Tab(text: 'Pedido Diario'),
            ],
          ),
        ),
        drawer: UsuarioDrawer(),
        body: TabBarView(
          children: [
            PedidosPage(),
            IngredientesPage(),
            ProductosPage(),
            UsuariosPage(),
            IngresoDiario(),
            ReporteDiarioPage(),
          ],
        ),
      ),
    );
  }
}
