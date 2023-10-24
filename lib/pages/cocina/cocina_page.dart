import 'package:flutter/material.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/widgets/error_retry_widget.dart';
import 'package:jerupos/widgets/pedido_card.dart';
import 'package:jerupos/widgets/user_drawer.dart';

class CocinaPage extends StatefulWidget {
  @override
  State<CocinaPage> createState() => _CocinaPageState();
}

class _CocinaPageState extends State<CocinaPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JeruPOS'),
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
              scrollDirection: Axis.horizontal,
              itemCount: pedidos.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                  width: 200,
                  child: PedidoCard(
                    pedido: pedidos[index],
                  ),
                );
              },
            ),
    );
  }
}
