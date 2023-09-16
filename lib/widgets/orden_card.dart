import 'package:flutter/material.dart';

class OrdenCard extends StatelessWidget {
  final String numeroOrden;
  final String numeroMesa;
  final String horaPedido;
  final bool paraServir;
  final List<String> productos;
  final Function()? onButtonPressed;
  final String? buttonLabel;

  const OrdenCard({
    required this.numeroOrden,
    required this.numeroMesa,
    required this.horaPedido,
    required this.paraServir,
    required this.productos,
    this.onButtonPressed,
    this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
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
                  Text('#$numeroOrden'),
                  Spacer(),
                  Text('${paraServir ? "Mesa $numeroMesa" : "Para Llevar"}'),
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  Text('$horaPedido'),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    return Text(productos[index]);
                  },
                ),
              ),
            ],
          ),
        ),
        onButtonPressed != null
            ? Positioned(
                bottom: -8,
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
