import 'package:flutter/material.dart';
import 'package:jerupos/pages/login_page.dart';
import 'package:jerupos/services/auth_service.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/widgets/pedido_card.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CocinaPage extends StatefulWidget {
  @override
  State<CocinaPage> createState() => _CocinaPageState();
}

class _CocinaPageState extends State<CocinaPage> {
  Future<Map<String, dynamic>>? usuario;

  @override
  void initState() {
    super.initState();
    usuario = obtenerUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JeruPOS'),
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
      body: FutureBuilder(
        future: PedidoService.list(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                  width: 200,
                  child: PedidoCard(
                    pedido: snapshot.data[index],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> obtenerUsuario() async {
    final String? token = await AuthService.getToken();
    if (token != null) {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken;
    }
    return {};
  }
}
