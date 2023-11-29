import 'package:flutter/material.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/widgets/pedido_form_page.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/widgets/pedido_tile.dart';

class PedidosPage extends StatefulWidget {
  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  List<Pedido> pedidos = [];
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  Future<void> _loadPedidos() async {
    try {
      List<Pedido> fetchedPedidos = await PedidoService.list();
      setState(() {
        pedidos = fetchedPedidos;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          errorMsg = 'Error: $error';
        });
      }
    }
  }

  void refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos Actuales'),
        automaticallyImplyLeading: false,
      ),
      body: errorMsg.isNotEmpty
          ? Center(child: Text(errorMsg))
          : ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (BuildContext context, int index) {
                if (pedidos[index].estado != 'PAGADO') {
                  return PedidoTile(
                    pedido: pedidos[index],
                    onAction: refreshList,
                  );
                } else {
                  return Container();
                }
              },
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
