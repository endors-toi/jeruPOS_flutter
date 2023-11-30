import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/services/network_service.dart';
import 'package:jerupos/utils/mostrar_toast.dart';
import 'package:jerupos/widgets/pedido_form_page.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/utils/error_retry.dart';
import 'package:jerupos/widgets/pedido_card.dart';
import 'package:jerupos/widgets/usuario_drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GarzonPage extends StatefulWidget {
  @override
  State<GarzonPage> createState() => _GarzonPageState();
}

class _GarzonPageState extends State<GarzonPage> with TickerProviderStateMixin {
  WebSocketChannel? _channel;
  Timer? _timer;
  bool ordenarPorNumOrden = true;
  List<Pedido> pedidos = [];
  List<Pedido> pedidosActivos = [];
  String errorMsg = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setOrientation();
    _initializePedidos();
    _connect();
  }

  @override
  void dispose() {
    _timer!.cancel();
    _channel!.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('JeruPOS'),
          backgroundColor: Colors.orange,
          actions: [
            IconButton(
              onPressed: () {
                _connect();
              },
              icon: Icon(MdiIcons.reload),
            ),
          ]),
      drawer: UsuarioDrawer(),
      body: errorMsg.isNotEmpty
          ? ErrorRetry(
              errorMsg: errorMsg,
              onRetry: () {
                setState(() {
                  errorMsg = '';
                });
                _initializePedidos();
              })
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 56),
                    Expanded(
                      child: Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(4)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PedidoFormPage(),
                              ),
                            ).then((_) {
                              setState(() {
                                pedidos.clear();
                                pedidosActivos.clear();
                              });
                              _initializePedidos();
                            });
                          },
                          child: Text("Nuevo Pedido",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        ordenarPorNumOrden
                            ? MdiIcons.sortClockAscendingOutline
                            : MdiIcons.sortNumericAscending,
                        size: 36,
                      ),
                      onPressed: toggleSort,
                    ),
                  ],
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(8),
                  child: pedidosActivos.isEmpty
                      ? Center(
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  'No hay pedidos activos',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                        )
                      : MasonryGridView.builder(
                          //TODO: WebSocket
                          gridDelegate:
                              SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: pedidosActivos.length,
                          itemBuilder: (context, index) {
                            Pedido pedido = pedidosActivos[index];
                            return PedidoCard(
                              pedido: pedido,
                              onLongPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PedidoFormPage(
                                      id: pedido.id!,
                                    ),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    pedidos.clear();
                                    pedidosActivos.clear();
                                  });
                                  _initializePedidos();
                                });
                              },
                              ordenarPorNumOrden: ordenarPorNumOrden,
                            );
                          },
                        ),
                )),
              ],
            ),
    );
  }

  /* MÉTODOS */

  void _initializePedidos() async {
    await PedidoService.list().then((value) {
      setState(() {
        pedidos.addAll(value);
        pedidosActivos = pedidos
            .where((pedido) => pedido.estado != 'PAGADO' && pedido.mesa != null)
            .toList();
        pedidosActivos.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        errorMsg = "No se pudo cargar pedidos.\n" + error.toString();
      });
    });
  }

  void toggleSort() {
    setState(() {
      ordenarPorNumOrden = !ordenarPorNumOrden;
      pedidosActivos.sort((a, b) {
        if (ordenarPorNumOrden) {
          return (b.id ?? 0).compareTo(a.id ?? 0);
        } else {
          return (a.mesa ?? 0).compareTo(b.mesa ?? 0);
        }
      });
    });
    mostrarToast("Orden ${ordenarPorNumOrden ? 'cronológico' : 'por mesa'}");
  }

  void _setOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://' + getServerIP() + '/ws/pedidos/'),
    );

    _timer = Timer.periodic(Duration(seconds: 20), (timer) {
      _channel!.sink.add(json.encode({"message": "ping"}));
    });

    _channel!.stream.listen((message) {
      Map<String, dynamic> data = json.decode(message);
      if (data['message'] == 'pong') {
        print(data);
      }
      if (data['type'] == 'pedido_update') {
        if (data['action'] == 'create') {
          _recibirPedidoNuevo(data['pedido']);
        }
        if (data['action'] == 'update') {
          _recibirPedidoActualizado(data['pedido']);
        }
      }
    });
  }

  void _recibirPedidoNuevo(pedido) {}

  void _recibirPedidoActualizado(pedido) {}
}
