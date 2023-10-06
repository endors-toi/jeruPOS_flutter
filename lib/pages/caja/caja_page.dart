import 'package:flutter/material.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/widgets/pedido_tile.dart';

import '../../services/auth_service.dart';
import '../login_page.dart';

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
      endDrawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 255, 145),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40.0,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Usuario",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                AuthService.logout();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route route) => false);
              },
            ),
          ],
        ),
      ),
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
