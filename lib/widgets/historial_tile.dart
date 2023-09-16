import 'package:flutter/material.dart';

class HistorialTile extends StatelessWidget {
  final String numeroOrden;
  final String numeroMesa;
  final String horaPedido;
  final bool paraServir;
  final List<String> productos;

  const HistorialTile({
    required this.numeroOrden,
    required this.numeroMesa,
    required this.horaPedido,
    required this.paraServir,
    required this.productos,
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
            Text('Orden #$numeroOrden'),
            Spacer(),
            Text('$horaPedido'),
          ]),
          Text(
              textAlign: TextAlign.right,
              '${paraServir ? "Mesa $numeroMesa" : "Para Llevar"}'),
          SizedBox(height: 10.0),
          Text('Pedido:'),
          ...productos.map((producto) => Text('$producto')).toList(),
        ],
      ),
    );
  }
}
