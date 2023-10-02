import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PedidoCard extends StatelessWidget {
  final Map<String, dynamic> pedido;
  final Function()? onButtonPressed;
  final String? buttonLabel;
  final Map<String, dynamic> productos = {
    '1': {'nombre': 'Grande Mixto', 'cantidad': 2, 'precio_salida': 15.99},
    '2': {'nombre': 'Grande Pollo', 'cantidad': 1, 'precio_salida': 9.99},
  };

  PedidoCard({
    required this.pedido,
    this.onButtonPressed,
    this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
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
                  shrinkWrap: true, // this will make it as big as its content
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    String key = productos.keys.elementAt(index);
                    return Text(
                        "${productos[key]['cantidad']} x ${productos[key]['nombre']}");
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
