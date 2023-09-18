import 'package:flutter/material.dart';
import 'package:jerupos/data/models.dart';

class OrdenCard extends StatelessWidget {
  final Orden orden;
  final String? numeroMesa;
  final Function()? onButtonPressed;
  final String? buttonLabel;

  const OrdenCard({
    required this.orden,
    this.numeroMesa,
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
                  Text('#$orden.idOrden'),
                  Spacer(),
                  Text('$numeroMesa ? "Mesa $numeroMesa" : "Para Llevar"}'),
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  Text('$orden.timeStamp'),
                ],
              ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: orden.productos.length,
              //     itemBuilder: (context, index) {
              //       return Text(orden.productos[index].nombre);
              //     },
              //   ),
              // ),
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
