import 'package:flutter/material.dart';
import 'package:jerupos/widgets/historial_tile.dart';
import 'package:jerupos/data/orders.dart';

class HistorialPage extends StatefulWidget {
  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  @override
  Widget build(BuildContext context) {
    // Sort the orders in descending order based on the order number
    pastOrders.sort((a, b) => b['numeroOrden'].compareTo(a['numeroOrden']));

    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Pedidos'),
      ),
      body: pastOrders.isEmpty
          ? Center(
              child: Text(
                'No hay pedidos anteriores',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Container(
              margin: EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: pastOrders.length,
                itemBuilder: (context, index) {
                  final order = pastOrders[index];
                  return HistorialTile(
                    numeroOrden: order['numeroOrden'].toString(),
                    numeroMesa: order['numeroMesa'].toString(),
                    horaPedido: order['horaPedido'].toString(),
                    paraServir: order['paraServir'],
                    productos: List<String>.from(order['productos']),
                  );
                },
              ),
            ),
    );
  }
}
