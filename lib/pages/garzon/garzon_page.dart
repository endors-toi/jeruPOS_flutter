import 'package:flutter/material.dart';
import 'package:jerupos/pages/garzon/pedido_form_page.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/widgets/pedido_card.dart';
import 'package:jerupos/widgets/user_drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GarzonPage extends StatefulWidget {
  @override
  State<GarzonPage> createState() => _GarzonPageState();
}

class _GarzonPageState extends State<GarzonPage> {
  bool sortByOrderNumber = true;
  List<dynamic> pedidos = [];
  List<dynamic> pedidosActivos = [];

  @override
  void initState() {
    super.initState();
    PedidoService.list().then((value) {
      setState(() {
        pedidos.addAll(value);
        pedidosActivos =
            pedidos.where((pedido) => pedido['estado'] != 'PAGADO').toList();
        pedidosActivos.sort((a, b) => (b['id'] ?? 0).compareTo(a['id'] ?? 0));
      });
    });
  }

  void toggleSort() {
    setState(() {
      sortByOrderNumber = !sortByOrderNumber;
      pedidosActivos.sort((a, b) {
        if (sortByOrderNumber) {
          return (b['id'] ?? 0).compareTo(a['id'] ?? 0);
        } else {
          return (a['mesa'] ?? 0).compareTo(b['mesa'] ?? 0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JeruPOS'),
        backgroundColor: Colors.orange,
      ),
      drawer: UserDrawer(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 56),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    style: ButtonStyle(elevation: MaterialStateProperty.all(4)),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PedidoFormPage(),
                        ),
                      );
                      if (result != null && result == 'refresh') {
                        setState(() {});
                      }
                    },
                    child: Text("Nuevo Pedido"),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  sortByOrderNumber
                      ? MdiIcons.sortClockAscendingOutline
                      : MdiIcons.sortNumericAscending,
                  size: 32,
                ),
                onPressed: toggleSort,
              ),
            ],
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(8),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: pedidosActivos.length,
              itemBuilder: (BuildContext context, int index) {
                return PedidoCard(
                  pedido: pedidosActivos[index],
                  onTap: (TapUpDetails details) async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PedidoFormPage(id: pedidosActivos[index]['id']),
                      ),
                    );
                    if (result == 'refresh') {
                      setState(() {});
                    }
                  },
                  buttonLabel: Text("Editar"),
                );
              },
            ),
          )),
        ],
      ),
    );
  }
}
