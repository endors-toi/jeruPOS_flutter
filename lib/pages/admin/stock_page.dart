import 'package:flutter/material.dart';
import 'package:jerupos/services/ingrediente_service.dart';

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
        title: Text('Control de Stock'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder(
          future: IngredienteService.list(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return DataTable(
                columnSpacing: 44,
                columns: [
                  DataColumn(label: Text('Ingrediente')),
                  DataColumn(label: Text('Existencias')),
                  DataColumn(label: Text('Abastecer')),
                ],
                rows: List<DataRow>.generate(
                  snapshot.data.length,
                  (index) => DataRow(
                    cells: [
                      DataCell(Text(
                        snapshot.data[index]['nombre'].toString(),
                      )),
                      DataCell(Text(
                        '${snapshot.data[index]['cantidad_disponible'].toString()} ${snapshot.data[index]['unidad'].toString()}',
                      )),
                      DataCell(IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          // Implement your abastecer logic here
                        },
                      )),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
