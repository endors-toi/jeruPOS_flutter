import 'package:flutter/material.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/widgets/pedido_tile.dart';
import 'package:jerupos/widgets/user_drawer.dart';

class CajaPage extends StatefulWidget {
  @override
  _CajaPageState createState() => _CajaPageState();
}

class _CajaPageState extends State<CajaPage> {
  Future<List<Map<String, dynamic>>>? futureOrders;

  void refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caja Dashboard'),
        backgroundColor: Colors.orange,
      ),
      drawer: UserDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: PedidoService.list(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data![index]['estado'] != 'PAGADO') {
                    return PedidoTile(
                      pedido: snapshot.data![index],
                      onAction: refreshList,
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle new orders or other actions
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
