import 'package:flutter/material.dart';
import 'package:jerupos/pages/garzon/editar_pedido_page.dart';
import 'package:jerupos/pages/garzon/nuevo_pedido_page.dart';
import 'package:jerupos/widgets/orden_card.dart';
import 'package:jerupos/data/orders.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ComandaPage extends StatefulWidget {
  @override
  State<ComandaPage> createState() => _ComandaPageState();
}

class _ComandaPageState extends State<ComandaPage> {
  static int numeroOrden = 0;
  bool sortByOrderNumber = true;

  void toggleSort() {
    setState(() {
      sortByOrderNumber = !sortByOrderNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sortedOrders = [...currentOrders];

    if (sortByOrderNumber) {
      sortedOrders.sort((a, b) {
        int numA = b['numeroOrden'] is String
            ? int.parse(b['numeroOrden'])
            : b['numeroOrden'];
        int numB = a['numeroOrden'] is String
            ? int.parse(a['numeroOrden'])
            : a['numeroOrden'];
        return numA.compareTo(numB);
      });
    } else {
      sortedOrders.sort((a, b) {
        int numA = a['numeroMesa'] is String
            ? int.parse(a['numeroMesa'])
            : a['numeroMesa'];
        int numB = b['numeroMesa'] is String
            ? int.parse(b['numeroMesa'])
            : b['numeroMesa'];
        return numA.compareTo(numB);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Stack(
          alignment: Alignment.centerRight,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final nuevaOrden = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NuevoPedidoPage(),
                    ),
                  );
                  if (nuevaOrden != null) {
                    setState(() {
                      numeroOrden++;
                      nuevaOrden['numeroOrden'] = numeroOrden;
                      currentOrders.add(nuevaOrden);
                    });
                  }
                },
                child: Text("Nuevo Pedido"),
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
      ),
      body: currentOrders.isEmpty
          ? Center(
              child: Text(
                "Sin pedidos activos",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemCount: sortedOrders.length,
              itemBuilder: (context, index) {
                final order = sortedOrders[index];
                return OrdenCard(
                  numeroOrden: order['numeroOrden'].toString(),
                  numeroMesa: order['numeroMesa'].toString(),
                  horaPedido: order['horaPedido'].toString(),
                  paraServir: order['paraServir'],
                  productos: List<String>.from(order['productos']),
                  onButtonPressed: () async {
                    int numOrden = order['numeroOrden'];
                    int indexOrden = currentOrders.indexWhere(
                        (orden) => orden['numeroOrden'] == numOrden);
                    Map<String, dynamic> orden = currentOrders[indexOrden];
                    final cambiosOrden = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EditarPedidoPage(orden: orden);
                    }));
                    if (cambiosOrden != null) {
                      setState(() {
                        orden['numeroMesa'] = cambiosOrden['numeroMesa'];
                        orden['productos'] = cambiosOrden['productos'];
                        currentOrders[indexOrden] = orden;
                      });
                    }
                  },
                  buttonLabel: "Editar",
                );
              },
            ),
    );
  }
}
