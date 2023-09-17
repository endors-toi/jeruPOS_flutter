import 'package:flutter/material.dart';
import 'package:jerupos/pages/cocina/historial_page.dart';
import 'package:jerupos/widgets/orden_card.dart';
import 'package:jerupos/data/orders.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CocinaPage extends StatefulWidget {
  @override
  State<CocinaPage> createState() => _CocinaPageState();
}

class _CocinaPageState extends State<CocinaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Pedidos'),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistorialPage()));
              },
              icon: Icon(
                MdiIcons.history,
                size: 32,
              ),
            ),
          ],
        ),
      ),
      body: currentOrders.isEmpty
          ? Center(
              child: Text(
                "Sin pedidos activos",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemCount: currentOrders.length,
              itemBuilder: (context, index) {
                final order = currentOrders[index];
                return OrdenCard(
                  numeroOrden: order['numeroOrden'].toString(),
                  numeroMesa: order['numeroMesa'].toString(),
                  horaPedido: order['horaPedido'].toString(),
                  paraServir: order['paraServir'],
                  productos: List<String>.from(order['productos']),
                  onButtonPressed: () {
                    // Selecciona orden a marcar como lista usando el # de orden
                    int numOrden = order['numeroOrden'];
                    int indexOrden = currentOrders.indexWhere(
                        (orden) => orden['numeroOrden'] == numOrden);
                    if (indexOrden != -1) {
                      setState(() {
                        // Mueve la orden a la lista compartida de pedidos pasados 'pastOrders' y la remueve de 'currentOrders'
                        pastOrders.add(currentOrders[indexOrden]);
                        currentOrders.removeAt(indexOrden);
                      });
                    }
                  },
                  buttonLabel: "Listo",
                );
              },
            ),
    );
  }
}
