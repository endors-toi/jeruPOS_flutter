import 'package:flutter/material.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/pages/cocina/reporte_diario.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/utils/error_retry.dart';
import 'package:jerupos/widgets/pedido_card.dart';
import 'package:jerupos/widgets/usuario_drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'dart:math';

class CocinaPage extends StatefulWidget {
  @override
  State<CocinaPage> createState() => _CocinaPageState();
}

class _CocinaPageState extends State<CocinaPage> with TickerProviderStateMixin {
  List<Pedido> _pedidos = [];
  List<Pedido> _pedidosAnimados = [];
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();
  ScrollController _pedidosListController = ScrollController();

  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _loadPedidos();
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
              _addItem(_pedidos[random.nextInt(_pedidos.length)]);
            },
          ),
          IconButton(
            icon: Icon(MdiIcons.minus),
            onPressed: () {
              _removeItem(0);
            },
          ),
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
                            _loadPedidos();
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
                      return SlideTransition(
                        key: UniqueKey(),
                        position: Tween<Offset>(
                          begin: Offset(1, 0),
                          end: Offset(0, 0),
                        ).animate(animation),
                        child: PedidoCard(pedido: _pedidos[index]),
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
  Future<void> _loadPedidos() async {
    List<Pedido> pedidos = await PedidoService.list();
    setState(() {
      _pedidos =
          pedidos.where((pedido) => pedido.estado == "PENDIENTE").toList();
    });
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
  void _addItem(Pedido pedido) {
    _pedidosAnimados.add(pedido);
    _animatedListKey.currentState!.insertItem(
      _pedidosAnimados.length - 1,
      duration: Duration(milliseconds: 1000),
    );
  }

  void _removeItem(int index) {
    _animatedListKey.currentState!.removeItem(
      index,
      (_, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: Card(
            color: Colors.orange,
            child: Container(color: Colors.orange),
          ),
        );
      },
      duration: Duration(milliseconds: 500),
    );
    _pedidosAnimados.removeAt(index);
  }
}
