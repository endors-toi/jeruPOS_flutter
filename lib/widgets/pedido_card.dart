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
  double _screenWidth = 0;
  double _scaledSize = 0;

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
    _screenWidth = MediaQuery.of(context).size.width;
    _scaledSize = _screenWidth * 0.02;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: _esGarzon ? null : constraints.maxHeight,
          width: _esGarzon ? null : _screenWidth / 3.5,
          padding: EdgeInsets.only(right: 8),
          margin: EdgeInsets.only(bottom: 8),
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
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 246, 227),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: _scaledSize * .3),
                      child: Divider(
                        thickness:
                            _esGarzon ? _scaledSize / 4 : _scaledSize / 8,
                        color: widget.ordenarPorNumOrden ?? true
                            ? null
                            : Colors.orange,
                      ),
                    ),
                    _body(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header() {
    final String fTimestamp =
        DateFormat('hh:mm').format(widget.pedido.timestamp!);
    return Padding(
      padding: _esGarzon
          ? EdgeInsets.fromLTRB(
              _scaledSize * 1.5, _scaledSize * 1.5, _scaledSize * 1.5, 0)
          : EdgeInsets.fromLTRB(
              _scaledSize * .8, _scaledSize * .8, _scaledSize * .8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                  backgroundColor:
                      widget.ordenarPorNumOrden ?? true ? null : Colors.orange,
                  radius: _esGarzon ? _scaledSize * 3 : _scaledSize * 1.2,
                  child: Text(
                      widget.ordenarPorNumOrden ?? true
                          ? '${widget.pedido.id}'
                          : '${widget.pedido.mesa}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              _esGarzon ? _scaledSize * 3 : _scaledSize))),
              Spacer(),
              widget.ordenarPorNumOrden ?? true
                  ? Text(
                      widget.pedido.mesa != null
                          ? "Mesa ${widget.pedido.mesa}"
                          : "Para Llevar",
                      style: TextStyle(
                          fontSize:
                              _esGarzon ? _scaledSize * 2.5 : _scaledSize),
                    )
                  : Text("Pedido ${widget.pedido.id}",
                      style: TextStyle(fontSize: _scaledSize * 2)),
            ],
          ),
          Row(
            children: [
              widget.pedido.estado == 'PENDIENTE'
                  ? AnimatedEllipsis(
                      size: _esGarzon ? _scaledSize * 3 : _scaledSize * .8)
                  : Text(''),
              Spacer(),
              Text('$fTimestamp',
                  style: TextStyle(
                      fontSize:
                          _esGarzon ? _scaledSize * 2.1 : _scaledSize * .8)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body() {
    List<Widget> productos = widget.pedido.productos!.map((producto) {
      return Text(
        "${producto.cantidad} ${producto.nombre}",
        style: TextStyle(fontSize: _esGarzon ? _scaledSize * 2 : _scaledSize),
        overflow: TextOverflow.ellipsis,
      );
    }).toList();
    return _esGarzon
        ? Container(
            margin: EdgeInsets.fromLTRB(
                _scaledSize * 1.3, 0, _scaledSize * 1.3, _scaledSize * 1.3),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: productos,
            ))
        : Expanded(
            child: Container(
                margin: EdgeInsets.fromLTRB(
                    _scaledSize * .8, 0, _scaledSize * .8, _scaledSize * .8),
                child: ListView(
                  shrinkWrap: true,
                  children: productos,
                )),
          );
  }
}
