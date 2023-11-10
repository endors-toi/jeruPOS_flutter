import 'package:flutter/material.dart';
import 'package:jerupos/models/ingrediente.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class IngredienteTile extends StatelessWidget {
  final Ingrediente ingrediente;

  IngredienteTile({required this.ingrediente});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: [
        Expanded(
            flex: 3,
            child: Text(
              "${ingrediente.nombre}",
              style: TextStyle(fontSize: 24),
            )),
        Expanded(
            flex: 2,
            child: Text(
              "${ingrediente.cantidadDisponible}${ingrediente.unidad}",
              style: TextStyle(fontSize: 18),
            )),
        IconButton(
            icon: Icon(MdiIcons.chevronRightCircle, size: 36),
            onPressed: () {
              // nav to ingrediente detail page
            }),
      ]),
    );
  }
}
