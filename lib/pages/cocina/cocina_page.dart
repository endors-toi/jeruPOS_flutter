import 'dart:async';
import 'dart:convert';

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
import 'package:wakelock/wakelock.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CocinaPage extends StatefulWidget {
  @override
  State<CocinaPage> createState() => _CocinaPageState();
}

class _CocinaPageState extends State<CocinaPage> with TickerProviderStateMixin {
  List<Pedido> _pedidos = [];
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();
  ScrollController _pedidosListController = ScrollController();

  Timer? _timer;
  WebSocketChannel? _channel;

  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _setOrientation();
    Wakelock.enable();
    _initializePedidos();
    _connect();
  }

  @override
  void dispose() {
    _pedidosListController.dispose();
    _timer!.cancel();
    _channel!.sink.close();
    Wakelock.disable();
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
            icon: Icon(MdiIcons.launch),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReporteDiario()));
            },
          )
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
                          key: Key(_pedidos[index].id.toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _discardPedidoCard(index);
                            pedido.estado = "PREPARADO";
                            PedidoService.updatePATCH(pedido);
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

  void _recibirPedidoNuevo(pedido) async {
    pedido = Pedido.fromJson(pedido);
    pedido.productos = await PedidoService.getProductosPedido(pedido.id);
    _addPedidoCard(pedido);
  }

  void _recibirPedidoActualizado(pedido) async {
    pedido = Pedido.fromJson(pedido);
    pedido.productos = await PedidoService.getProductosPedido(pedido.id);
    int index = _pedidos.indexWhere((p) => p.id == pedido.id);
    if (index != -1) {
      _pedidos[index] = pedido;
      _animatedListKey.currentState!
          .removeItem(index, (context, animation) => Container());
      _animatedListKey.currentState!
          .insertItem(index, duration: Duration(milliseconds: 1000));
    }
  }
}
