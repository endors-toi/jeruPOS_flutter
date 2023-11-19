import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/pages/cocina/reporte_diario.dart';
import 'package:jerupos/services/network_service.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/utils/error_retry.dart';
import 'package:jerupos/widgets/pedido_card.dart';
import 'package:jerupos/widgets/usuario_drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'dart:math';

import 'package:web_socket_channel/web_socket_channel.dart';

class CocinaPage extends StatefulWidget {
  @override
  State<CocinaPage> createState() => _CocinaPageState();
}

class _CocinaPageState extends State<CocinaPage> with TickerProviderStateMixin {
  List<Pedido> _pedidos = [];
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();
  ScrollController _pedidosListController = ScrollController();
  WebSocketChannel? _channel;

  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _setOrientation();
    // _initializePedidos();
    _connect();
  }

  @override
  void dispose() {
    _pedidosListController.dispose();
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
            icon: Icon(MdiIcons.plus),
            onPressed: () {
              Random random = new Random();
              _addPedidoCard(_pedidos[random.nextInt(_pedidos.length)]);
            },
          ),
          IconButton(
            icon: Icon(MdiIcons.minus),
            onPressed: () {
              // _removeItem(0);
              _pedidos.clear();
            },
          ),
          IconButton(
            icon: Icon(MdiIcons.refresh),
            onPressed: () {
              _initializePedidos();
            },
          ),
          IconButton(
            icon: Icon(MdiIcons.logout),
            onPressed: () {
              _connect();
            },
          ),
          // IconButton(
          //   icon: Icon(MdiIcons.launch),
          //   onPressed: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => ReporteDiario()));
          //   },
          // )
        ],
      ),
      drawer: UsuarioDrawer(),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _errorMsg.isNotEmpty
                ? Center(
                    child: ErrorRetry(
                        errorMsg: _errorMsg,
                        onRetry: () {
                          setState(() {
                            _errorMsg = '';
                            _initializePedidos();
                          });
                        }),
                  )
                : AnimatedList(
                    key: _animatedListKey,
                    scrollDirection: Axis.horizontal,
                    controller: _pedidosListController,
                    physics: NeverScrollableScrollPhysics(),
                    initialItemCount: _pedidos.length,
                    itemBuilder: (context, index, animation) {
                      Pedido pedido = _pedidos[index];
                      return SlideTransition(
                        key: UniqueKey(),
                        position: Tween<Offset>(
                                begin: Offset(
                                    MediaQuery.of(context).size.width / 100, 0),
                                end: Offset(0, 0))
                            .animate(animation),
                        child: Dismissible(
                          key: Key(_pedidos[index]
                              .id
                              .toString()), // Ensure this key is unique for each item.
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _discardPedidoCard(index);
                            pedido.estado = "PREPARADO";
                            PedidoService.updatePATCH(pedido)
                                .then((value) => print(value));
                          },
                          child: PedidoCard(pedido: pedido),
                        ),
                      );
                    },
                  ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) => _onScroll(details),
              onHorizontalDragEnd: (details) => _onScrollEnd(details),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.orange,
                      Colors.white,
                    ],
                    radius: 10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* MÉTODOS */

  // inicializaciones
  Future<void> _initializePedidos() async {
    List<Pedido> pedidos = await PedidoService.list();
    pedidos = pedidos.where((pedido) => pedido.estado == "PENDIENTE").toList();
    for (Pedido pedido in pedidos) {
      _addPedidoCard(pedido);
      await Future.delayed(Duration(milliseconds: 500));
      if (_pedidos.length > 10) break;
    }
  }

  // scroll de pedidos
  void _onScroll(DragUpdateDetails details) {
    int scrollSpeed = 2;

    double scrollDelta = details.delta.dx * scrollSpeed;
    double newOffset = _pedidosListController.offset - scrollDelta;

    newOffset =
        newOffset.clamp(0, _pedidosListController.position.maxScrollExtent);
    _pedidosListController.jumpTo(newOffset);
  }

  void _onScrollEnd(DragEndDetails details) {
    double inertiaFactor = 0.1;
    int stopSpeed = 0;

    double scrollVelocity = details.velocity.pixelsPerSecond.dx * inertiaFactor;
    double newOffset = _pedidosListController.offset - scrollVelocity;

    newOffset =
        newOffset.clamp(0, _pedidosListController.position.maxScrollExtent);

    _pedidosListController.animateTo(newOffset,
        duration:
            Duration(milliseconds: 500 - ((stopSpeed.clamp(0, 4) + 1) * 90)),
        curve: Curves.easeOutCubic);
  }

  // métodos AnimatedList
  void _addPedidoCard(Pedido pedido) {
    _pedidos.add(pedido);
    _animatedListKey.currentState!.insertItem(
      _pedidos.length - 1,
      duration: Duration(milliseconds: 1000),
    );
  }

  void _discardPedidoCard(int index) {
    _pedidos.removeAt(index);
    _animatedListKey.currentState!
        .removeItem(index, (context, animation) => Container());
  }

  // otros métodos
  void _setOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://' + getServerIP() + '/ws/pedidos/'),
    );
  }
}
