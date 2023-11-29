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
    //TODO: Implementar WebSocket para actualizar pedidos en tiempo real
  }

  //TODO: Cambiar a FutureBuilder
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
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
                    child: Text('Nuevo Pedido',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(8),
                      minimumSize: MaterialStateProperty.all(Size(0, 60)),
                    ),
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PedidoFormPage()))
                          .then((value) => setState(() {
                                _initializePedidos();
                              }));
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: pedidos.length,
                    itemBuilder: (BuildContext context, int index) {
                      Pedido pedido = pedidos[index];
                      if (pedido.estado != 'PAGADO') {
                        return PedidoTile(
                          pedido: pedido,
                          onAction: () => setState(() {}),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
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
