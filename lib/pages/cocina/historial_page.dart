import 'package:flutter/material.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/widgets/historial_tile.dart';

class HistorialPage extends StatefulWidget {
  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Pedidos'),
      ),
      body: FutureBuilder(
        future: PedidoService.list(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<dynamic> pedidosPagados = snapshot.data!
                .where((pedido) => pedido['estado'] == 'PAGADO')
                .toList();

            if (pedidosPagados.isEmpty) {
              return Center(
                child: Text(
                  'No hay pedidos anteriores',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return Container(
                margin: EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: pedidosPagados.length,
                  itemBuilder: (context, index) {
                    final pedido = pedidosPagados[index];
                    return HistorialTile(
                      pedido: pedido,
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
