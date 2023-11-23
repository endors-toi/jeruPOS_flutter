import 'package:flutter/material.dart';
import 'package:jerupos/models/ingrediente.dart';

class IngredienteProductoTile extends StatefulWidget {
  final Ingrediente ingrediente;
  final Function(Ingrediente, bool) onSelected;
  final Function(double?) onCantidadChanged;

  IngredienteProductoTile({
    required this.ingrediente,
    required this.onSelected,
    required this.onCantidadChanged,
  }) : super(key: Key(ingrediente.id.toString()));

  @override
  _IngredienteProductoTileState createState() =>
      _IngredienteProductoTileState();
}

class _IngredienteProductoTileState extends State<IngredienteProductoTile> {
  bool isChecked = false;
  final TextEditingController _cantidadController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onTap() {
    setState(() {
      isChecked = !isChecked;
    });
    widget.onSelected(widget.ingrediente, isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: InkWell(
        onTap: _onTap,
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
                  if (value != null) {
                    _onTap();
                  }
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
                    ? TextFormField(
                        controller: _cantidadController,
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'Cantidad (${widget.ingrediente.unidad})',
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (_) {
                          double? cantidad =
                              double.tryParse(_cantidadController.text);
                          widget.onCantidadChanged(cantidad);
                        },
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
