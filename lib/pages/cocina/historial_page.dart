import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/utils/error_retry.dart';
import 'package:jerupos/widgets/historial_tile.dart';

class HistorialPage extends StatefulWidget {
  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  List<Pedido> pedidosPagados = [];
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  Future<void> _loadPedidos() async {
    try {
      final pedidos = await PedidoService.list();
      setState(() {
        pedidosPagados =
            pedidos.where((pedido) => pedido.estado == 'PAGADO').toList();
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
          ? ErrorRetry(
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
                  child: MasonryGridView.builder(
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 3
                          : 1,
                    ),
                    itemCount: pedidosPagados.length,
                    itemBuilder: (context, index) {
                      Pedido pedido = pedidosPagados[index];
                      return HistorialTile(
                        pedido: pedido,
                      );
                    },
                  ),
                ),
    );
  }
}
