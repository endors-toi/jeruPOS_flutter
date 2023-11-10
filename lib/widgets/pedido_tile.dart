import 'package:flutter/material.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/models/producto.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/utils/animated_ellipsis.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PedidoTile extends StatelessWidget {
  final Pedido pedido;
  final Function onAction;

  PedidoTile({
    required this.pedido,
    required this.onAction,
  });

  num calcularTotal() {
    num total = 0;
    List<Producto> productos = pedido.productos;
    productos.forEach((producto) {
      total += producto.precio! * producto.cantidad;
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("#${pedido.id}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                          "  ${pedido.timestamp!.hour}:${pedido.timestamp!.minute.toString().padLeft(2, '0')}")
                    ],
                  ),
                  Text(
                      pedido.nombreCliente != null
                          ? "\"${pedido.nombreCliente}\""
                          : pedido.mesa != null
                              ? "MESA ${pedido.mesa}"
                              : "",
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Expanded(flex: 1, child: Text('\$$total')),
            pedido.estado != "PAGADO"
                ? Expanded(flex: 1, child: AnimatedEllipsis())
                : Text("${pedido.estado}"),
            Expanded(
              flex: 2,
              child: InkWell(
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.checkCircle,
                      color: const Color.fromARGB(255, 33, 161, 38),
                      size: 32,
                    ),
                    Text("PAGADO",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
                onTap: () async {
                  pedido.estado = "PAGADO";
                  await PedidoService.update(pedido);
                  onAction();
                },
              ),
            )
          ],
        ));
  }
}
