import 'package:flutter/material.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/widgets/error_retry_widget.dart';
import 'package:jerupos/widgets/historial_tile.dart';

class HistorialPage extends StatefulWidget {
  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  List<dynamic> pedidosPagados = [];
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  // Function to fetch pedidos data
  Future<void> _loadPedidos() async {
    try {
      final pedidos = await PedidoService.list();
      setState(() {
        pedidosPagados =
            pedidos.where((pedido) => pedido['estado'] == 'PAGADO').toList();
      });
    } catch (error) {
      setState(() {
        errorMsg = 'No se pudo cargar pedidos.\n$error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Pedidos'),
      ),
      body: errorMsg.isNotEmpty
          ? ErrorRetryWidget(
              errorMsg: errorMsg,
              onRetry: () => _loadPedidos(),
            )
          : pedidosPagados.isEmpty
              ? Center(
                  child: Text(
                    'No hay pedidos anteriores',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : Container(
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
                ),
    );
  }
}
