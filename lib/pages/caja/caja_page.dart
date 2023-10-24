import 'package:flutter/material.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/widgets/error_retry_widget.dart';
import 'package:jerupos/widgets/pedido_tile.dart';
import 'package:jerupos/widgets/user_drawer.dart';

class CajaPage extends StatefulWidget {
  @override
  _CajaPageState createState() => _CajaPageState();
}

class _CajaPageState extends State<CajaPage> {
  List<Pedido> pedidos = [];
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  // Function to fetch pedidos data
  Future<void> _loadPedidos() async {
    try {
      final fetchedPedidos = await PedidoService.list();
      setState(() {
        pedidos = fetchedPedidos;
      });
    } catch (error) {
      setState(() {
        errorMsg = 'No se pudo cargar pedidos.\n$error';
      });
    }
  }

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
      body: errorMsg.isNotEmpty
          ? ErrorRetryWidget(
              errorMsg: errorMsg,
              onRetry: () {
                setState(() {
                  errorMsg = '';
                  _loadPedidos();
                });
              })
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
        onPressed: () {
          // Handle new orders or other actions
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
