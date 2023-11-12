import 'package:flutter/material.dart';

void mostrarSnackBar(BuildContext context, String mensaje) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }
}
