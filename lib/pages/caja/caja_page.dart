import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/widgets/pedido_form_page.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/utils/error_retry.dart';
import 'package:jerupos/widgets/pedido_tile.dart';
import 'package:jerupos/widgets/usuario_drawer.dart';

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
    _setOrientation();
    _initializePedidos();
  }

  Future<void> _initializePedidos() async {
    try {
      final fetchedPedidos = await PedidoService.list();
      setState(() {
        pedidos = fetchedPedidos;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          errorMsg = 'No se pudo cargar pedidos.\n$error';
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
        title: Text('Caja Dashboard'),
        backgroundColor: Colors.orange,
      ),
      drawer: UsuarioDrawer(),
      body: errorMsg.isNotEmpty
          ? ErrorRetry(
              errorMsg: errorMsg,
              onRetry: () {
                setState(() {
                  errorMsg = '';
                  _initializePedidos();
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PedidoFormPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _setOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
