import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/utils/animated_ellipsis.dart';

class PedidoCard extends StatefulWidget {
  final Pedido pedido;
  final GestureLongPressCallback? onLongPress;
  final bool? ordenarPorNumOrden;

  PedidoCard({
    required this.pedido,
    this.onLongPress,
    this.ordenarPorNumOrden,
  });

  @override
  State<PedidoCard> createState() => _PedidoCardState();
}

class _PedidoCardState extends State<PedidoCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.5),
              blurRadius: 2,
              offset: Offset(4, 4),
              spreadRadius: -3,
            )
          ],
          borderRadius: BorderRadius.circular(18),
        ),
        child: Card(
          child: GestureDetector(
            onLongPress: widget.onLongPress,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 246, 227),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  _body(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _header() {
    final String fTimestamp =
        DateFormat('hh:mm').format(widget.pedido.timestamp!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
                backgroundColor:
                    widget.ordenarPorNumOrden ?? true ? null : Colors.orange,
                radius: 20,
                child: Text(
                    widget.ordenarPorNumOrden ?? true
                        ? '${widget.pedido.id}'
                        : '${widget.pedido.mesa}',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Spacer(),
            widget.ordenarPorNumOrden ?? true
                ? Text(
                    widget.pedido.mesa != null
                        ? "Mesa ${widget.pedido.mesa}"
                        : "Para Llevar",
                    style: TextStyle(fontSize: 16))
                : Text("Pedido ${widget.pedido.id}"),
          ],
        ),
        Row(
          children: [
            widget.pedido.estado == 'PENDIENTE'
                ? AnimatedEllipsis()
                : Text('🟢'),
            Spacer(),
            Text('$fTimestamp'),
          ],
        ),
        Divider(),
      ],
    );
  }

  Column _body() {
    List<Widget> productos = widget.pedido.productos.map((producto) {
      return Text("${producto.cantidad}x ${producto.nombre}");
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: productos,
    );
  }
}
