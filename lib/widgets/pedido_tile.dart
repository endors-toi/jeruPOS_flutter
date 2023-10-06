import 'package:flutter/material.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PedidoTile extends StatelessWidget {
  final Map<String, dynamic> pedido;
  final Function onAction;

  PedidoTile({
    required this.pedido,
    required this.onAction,
  });

  num calcularTotal() {
    num total = 0;
    List<dynamic> productos = pedido['productos'];
    productos.forEach((producto) {
      total += producto['precio'] * producto['cantidad'];
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final num total = calcularTotal();
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
            IconButton(
              icon: Icon(
                MdiIcons.checkCircle,
                color: const Color.fromARGB(255, 33, 161, 38),
                size: 32,
              ),
              onPressed: () async {
                pedido['estado'] = "PAGADO";
                await PedidoService.updatePATCH(pedido);
                onAction();
              },
            )
          ],
        ));
  }
}
