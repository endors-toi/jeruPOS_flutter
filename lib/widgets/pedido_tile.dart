import 'package:flutter/material.dart';

class PedidoTile extends StatelessWidget {
  final Map<String, dynamic> pedido;
  final Map<String, dynamic> productos = {
    '1': {'nombre': 'Grande Mixto', 'cantidad': 2, 'precio_salida': 5890},
    '2': {'nombre': 'Grande Pollo', 'cantidad': 1, 'precio_salida': 5690},
  };

  PedidoTile({
    required this.pedido,
  });

  int calcularTotal() {
    int total = 0;
    productos.forEach((key, value) {
      int precioSalida = value['precio_salida'];
      int cantidad = value['cantidad'];
      total += precioSalida * cantidad;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final int total = calcularTotal();
    return Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromARGB(255, 255, 222, 171), width: 1),
          borderRadius: BorderRadius.circular(12),
          color: Color.fromARGB(255, 255, 247, 234),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("#${pedido['id']}"),
                Text('Total: $total'),
              ],
            ),
            Spacer(),
            Text("${pedido['estado']}"),
          ],
        ));
  }
}
