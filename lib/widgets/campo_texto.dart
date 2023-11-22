import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final TextEditingController _controller;
  final String _label;

  CampoTexto({
    required TextEditingController controller,
    required String label,
  })  : _controller = controller,
        _label = label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration:
            InputDecoration(label: Text(_label), border: OutlineInputBorder()),
        controller: _controller,
      ),
    );
  }
}
