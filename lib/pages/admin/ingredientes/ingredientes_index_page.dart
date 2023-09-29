import 'package:flutter/material.dart';
import 'package:jerupos/widgets/table_row.dart';
import 'package:jerupos/services/ingrediente_service.dart';

class IngredientesIndexPage extends StatefulWidget {
  @override
  _IngredientesIndexPageState createState() => _IngredientesIndexPageState();
}

class _IngredientesIndexPageState extends State<IngredientesIndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingredientes'),
      ),
      body: Column(
        children: [
          TableRowWidget(
            items: ['', 'Disponible', 'Crítica', '', ''],
            header: true,
          ),
          Expanded(
              child: FutureBuilder(
            future: IngredienteService.list(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return TableRowWidget(items: [
                      snapshot.data[index]['nombre'],
                      snapshot.data[index]['cantidad_disponible'].toString(),
                      snapshot.data[index]['cantidad_critica'].toString(),
                      'edit',
                      'delete',
                    ]);
                  },
                );
              }
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add new ingrediente page
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
