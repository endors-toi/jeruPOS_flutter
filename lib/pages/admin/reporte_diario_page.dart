import 'package:flutter/material.dart';
import 'package:jerupos/models/item_pedido.dart';
import 'package:jerupos/services/pedido_diario_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ReporteDiarioPage extends StatefulWidget {
  @override
  _ReporteDiarioPageState createState() => _ReporteDiarioPageState();
}

class _ReporteDiarioPageState extends State<ReporteDiarioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Pedido Diario'),
      ),
      body: FutureBuilder(
        future: PedidoDiarioService.list(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                ItemPedido item = snapshot.data[index];
                if (item.selected) {
                  return ListTile(
                      leading: Icon(MdiIcons.circle), title: Text(item.nombre));
                }
                return Container();
              },
            );
          }
        },
      ),
    );
  }
}
