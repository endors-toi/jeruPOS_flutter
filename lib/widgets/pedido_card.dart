import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PedidoCard extends StatelessWidget {
  final Map<String, dynamic> pedido;
  final Function()? onButtonPressed;
  final String? buttonLabel;

  PedidoCard({
    required this.pedido,
    this.onButtonPressed,
    this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> productos = pedido['productos'] ?? [];
    final String fTimestamp =
        DateFormat('hh:mm').format(DateTime.parse(pedido['timestamp']));
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Stack(children: [
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('#${pedido['id']}'),
                  Spacer(),
                  Text(pedido['mesa'] != null
                      ? "Mesa ${pedido['mesa']}"
                      : "Para Llevar"),
                ],
              ),
              Row(
                children: [
                  Text('${pedido['estado']}'),
                  Spacer(),
                  Text('$fTimestamp'),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    var producto = productos[index];
                    int cantidadFalsa = 2;
                    return Text("$cantidadFalsa x ${producto['nombre']}");
                  },
                ),
              ),
            ],
          ),
        ),
        onButtonPressed != null
            ? Positioned(
                bottom: -3,
                right: 1,
                child: FilledButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero))),
                  onPressed: onButtonPressed,
                  child: Text(buttonLabel ?? 'default'),
                ),
              )
            : Container(),
      ]),
    );
  }
}
