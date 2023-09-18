import 'package:flutter/material.dart';
import 'package:jerupos/widgets/historial_tile.dart';
import 'package:jerupos/data/ordenes.dart';

class HistorialPage extends StatefulWidget {
  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  @override
  Widget build(BuildContext context) {
    // Ordena las órdenes por orden cronológico inverso (con el # de orden)
    // pastOrders.sort((a, b) => b.idOrden.compareTo(a.idOrden));

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
                  // final order = pastOrders[index];
                  // return HistorialTile();
                },
              ),
            ),
    );
  }
}
