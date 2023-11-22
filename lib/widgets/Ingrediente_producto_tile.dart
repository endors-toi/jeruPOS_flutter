import 'package:flutter/material.dart';
import 'package:jerupos/models/ingrediente.dart';

class IngredienteProductoTile extends StatefulWidget {
  final Ingrediente ingrediente;

  IngredienteProductoTile({
    required this.ingrediente,
  });

  @override
  _IngredienteProductoTileState createState() =>
      _IngredienteProductoTileState();
}

class _IngredienteProductoTileState extends State<IngredienteProductoTile> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Container(
        color: isChecked
            ? Colors.orangeAccent.withOpacity(0.4)
            : Colors.transparent,
        height: 80,
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
            Expanded(
              flex: 1,
              child: Text(
                widget.ingrediente.nombre,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              flex: 1,
              child: isChecked
                  ? TextField(
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: 'Cantidad (${widget.ingrediente.unidad})',
                        isDense: true,
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
