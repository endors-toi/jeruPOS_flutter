import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/models/producto_pedido.dart';

class HistorialTile extends StatelessWidget {
  final Pedido pedido;

  const HistorialTile({
    required this.pedido,
  });

  String get total {
    num total = 0;
    List<ProductoPedido> productos = pedido.productos!;
    productos.forEach((producto) {
      total += producto.precio! * producto.cantidad;
    });
    return '\$${total}';
  }

  @override
  Widget build(BuildContext context) {
    final String fTimestamp =
        DateFormat('dd/MM/yyyy HH:mm').format(pedido.timestamp!);
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.fromLTRB(0, 0, 12, 16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 246, 227),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 3,
            spreadRadius: 2,
            offset: Offset(6, 6),
          )
        ],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pedido #${pedido.id}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
            Text('$fTimestamp', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10.0),
            ...List<Widget>.from((pedido.productos!).map((producto) {
              return Text('${producto.cantidad} ${producto.nombre}',
                  style: TextStyle(fontSize: 18));
            }).toList()),
          ],
        ),
        Positioned(
            child: Text('$total',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            right: 0,
            bottom: -3),
      ]),
    );
  }
}
