import 'package:flutter/material.dart';
import 'package:jerupos/services/ingrediente_service.dart';
import 'package:jerupos/widgets/ingrediente_tile.dart';

class StockPage extends StatefulWidget {
  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Ajustes de Stock'),
      ),
      body: FutureBuilder(
        future: IngredienteService.list(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var ingrediente = snapshot.data[index];
                return IngredienteTile(ingrediente: ingrediente);
              },
            );
          }
        },
      ),
    );
  }
}
