import 'package:flutter/material.dart';
import 'package:jerupos/pages/garzon/pedido_form_page.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PedidosPage extends StatefulWidget {
  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  Future<List<Map<String, dynamic>>>? futureOrders;

  void refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos Actuales'),
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
                  return PedidoTile(
                    pedido: snapshot.data![index],
                    onDelete: refreshList,
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PedidoFormPage(),
            ),
          );
          if (result != null && result == 'refresh') {
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PedidoTile extends StatefulWidget {
  final Map<String, dynamic> pedido;
  final Function onDelete;

  PedidoTile({
    required this.pedido,
    required this.onDelete,
  });

  @override
  State<PedidoTile> createState() => _PedidoTileState();
}

class _PedidoTileState extends State<PedidoTile> {
  num calcularTotal() {
    num total = 0;
    List<dynamic> productos = widget.pedido['productos'];
    productos.forEach((producto) {
      total += producto['precio'] * producto['cantidad'];
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final num total = calcularTotal();
    return Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromARGB(255, 255, 222, 171), width: 1),
          borderRadius: BorderRadius.circular(12),
          color: Color.fromARGB(255, 255, 247, 234),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("#${widget.pedido['id']}"),
                Text('Total: $total'),
              ],
            ),
            Spacer(),
            IconButton(
                onPressed: () async {
                  await PedidoService.delete(widget.pedido['id']);
                  widget.onDelete();
                },
                icon: Icon(MdiIcons.delete)),
          ],
        ));
  }
}
