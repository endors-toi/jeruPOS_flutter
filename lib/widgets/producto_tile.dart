import 'package:flutter/material.dart';
import 'package:jerupos/models/producto.dart';

class ProductoTile extends StatelessWidget {
  final Producto producto;
  final GestureTapUpCallback? onTapUp;

  ProductoTile({required this.producto, this.onTapUp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: onTapUp,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(16),
          color: Color.fromARGB(255, 255, 246, 227),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                producto.nombre,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Text(
              "${producto.precio}",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
