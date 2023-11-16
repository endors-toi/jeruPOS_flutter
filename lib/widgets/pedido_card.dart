import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/models/usuario.dart';
import 'package:jerupos/utils/animated_ellipsis.dart';
import 'package:provider/provider.dart';

class PedidoCard extends StatefulWidget {
  final Pedido pedido;
  final bool? allowDiscard;
  final bool? ordenarPorNumOrden;
  final Function? onDiscard;
  final GestureLongPressCallback? onLongPress;

  PedidoCard({
    required this.pedido,
    this.allowDiscard,
    this.ordenarPorNumOrden,
    this.onDiscard,
    this.onLongPress,
  });

  @override
  State<PedidoCard> createState() => _PedidoCardState();
}

class _PedidoCardState extends State<PedidoCard> {
  bool _esGarzon = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var usuario = Provider.of<UsuarioProvider>(context);
    setState(() {
      _esGarzon = usuario.usuario!.rol == 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: EdgeInsets.only(right: 8),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
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

  Widget _body() {
    List<Text> productos = widget.pedido.productos.map((producto) {
      return Text("${producto.cantidad} ${producto.nombre}");
    }).toList();

    return Container(
        child: _esGarzon
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: productos,
              )
            : Expanded(
                child: ListView.builder(
                    itemCount: productos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return productos[index];
                    }),
              ));
  }
}
