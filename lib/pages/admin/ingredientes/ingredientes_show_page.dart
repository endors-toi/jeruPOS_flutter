import 'package:flutter/material.dart';

class IngredientesShowPage extends StatefulWidget {
  @override
  _IngredientesShowPageState createState() => _IngredientesShowPageState();
}

class _IngredientesShowPageState extends State<IngredientesShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ingredientes Management"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Nombre'),
            subtitle: Text('Example Name'),
          ),
          ListTile(
            title: Text('Cantidad Disponible'),
            subtitle: Text('100'),
          ),
          ListTile(
            title: Text('Cantidad Crítica'),
            subtitle: Text('20'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
