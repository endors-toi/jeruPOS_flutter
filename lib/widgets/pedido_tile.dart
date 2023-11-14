import 'package:flutter/material.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/models/producto.dart';
import 'package:jerupos/models/usuario.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/utils/animated_ellipsis.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class PedidoTile extends StatefulWidget {
  final Pedido pedido;
  final Function onAction;

  PedidoTile({
    required this.pedido,
    required this.onAction,
  });

  @override
  State<PedidoTile> createState() => _PedidoTileState();
}

class _PedidoTileState extends State<PedidoTile> {
  Usuario? usuario;

  num calcularTotal() {
    num total = 0;
    List<Producto> productos = widget.pedido.productos;
    productos.forEach((producto) {
      total += producto.precio! * producto.cantidad;
    });
    return total;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      this.usuario = Provider.of<UsuarioProvider>(context).usuario;
    });
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
                      Text("#${widget.pedido.id}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                          "  ${widget.pedido.timestamp!.hour}:${widget.pedido.timestamp!.minute.toString().padLeft(2, '0')}")
                    ],
                  ),
                  Text(
                      widget.pedido.nombreCliente != null
                          ? "\"${widget.pedido.nombreCliente}\""
                          : widget.pedido.mesa != null
                              ? "MESA ${widget.pedido.mesa}"
                              : "",
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Expanded(flex: 1, child: Text('\$$total')),
            widget.pedido.estado != "PAGADO"
                ? Expanded(flex: 1, child: AnimatedEllipsis())
                : Text("${widget.pedido.estado}"),
            usuario == null
                ? Container()
                : usuario!.rol != 4
                    ? Expanded(
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
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          onTap: () async {
                            widget.pedido.estado = "PAGADO";
                            await PedidoService.update(widget.pedido);
                            widget.onAction();
                          },
                        ),
                      )
                    : Container(),
          ],
        ));
  }
}
