import 'package:flutter/material.dart';
import 'package:jerupos/data/models.dart';

class HistorialTile extends StatelessWidget {
  final Orden orden;

  const HistorialTile({
    required this.orden,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('Orden #$orden.idOrden'),
            Spacer(),
            Text('$orden.timeStamp'),
          ]),
          // Text(
          //     textAlign: TextAlign.right,
          //     '${paraServir ? "Mesa $numeroMesa" : "Para Llevar"}'),
          // SizedBox(height: 10.0),
          // Text('Pedido:'),
          // ...productos.map((producto) => Text('$producto')).toList(),
        ],
      ),
    );
  }
}
