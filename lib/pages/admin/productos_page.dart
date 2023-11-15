import 'package:flutter/material.dart';
import 'package:jerupos/services/producto_service.dart';

class ProductosPage extends StatefulWidget {
  @override
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Productos'),
      ),
      body: FutureBuilder(
        future: ProductoService.list(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var producto = snapshot.data[index];
                return ListTile(
                  title: Text(producto.nombre),
                );
              },
            );
          }
        },
      ),
    );
  }
}
