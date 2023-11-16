import 'package:flutter/material.dart';
import 'package:jerupos/models/animations.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/pages/cocina/reporte_diario.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/utils/error_retry.dart';
import 'package:jerupos/widgets/pedido_card.dart';
import 'package:jerupos/widgets/usuario_drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CocinaPage extends StatefulWidget {
  @override
  State<CocinaPage> createState() => _CocinaPageState();
}

class _CocinaPageState extends State<CocinaPage> with TickerProviderStateMixin {
  late AnimatedEllipsisProvider _ellipsisProvider;
  ScrollController pedidosListController = ScrollController(
    initialScrollOffset: 0,
    keepScrollOffset: true,
  );
  String errorMsg = '';

  List<Pedido> pedidos = [];
  @override
  void initState() {
    super.initState();
    _loadPedidos();
    _ellipsisProvider = AnimatedEllipsisProvider(this);
  }

  @override
  void dispose() {
    pedidosListController.dispose();
    _ellipsisProvider.dispose();
    super.dispose();
  }

  Future<void> _loadPedidos() async {
    try {
      final fetchedPedidos = await PedidoService.list();
      setState(() {
        pedidos = fetchedPedidos
            .where((pedido) => pedido.estado != "PAGADO")
            .toList();
      });
    } catch (error) {
      setState(() {
        errorMsg = 'No se pudo cargar pedidos.\n$error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnimatedEllipsisProvider>(
      create: (_) => _ellipsisProvider,
      child: Scaffold(
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
              child: errorMsg.isNotEmpty
                  ? Center(
                      child: ErrorRetry(
                          errorMsg: errorMsg,
                          onRetry: () {
                            setState(() {
                              errorMsg = '';
                              _loadPedidos();
                            });
                          }),
                    )
                  : ListView.builder(
                      controller: pedidosListController,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: pedidos.length,
                      itemBuilder: (BuildContext context, int index) {
                        Pedido pedido = pedidos[index];
                        bool allowDiscard = index < 3;
                        return PedidoCard(
                          pedido: pedido,
                          allowDiscard: allowDiscard,
                          onDiscard: () {
                            setState(() {
                              pedidos.remove(pedido);
                            });
                          },
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
                )),
          ],
        ),
      ),
    );
  }

  void _onScroll(DragUpdateDetails details) {
    int scrollSpeed = 2;

    double scrollDelta = details.delta.dx * scrollSpeed;
    double newOffset = pedidosListController.offset - scrollDelta;

    newOffset =
        newOffset.clamp(0, pedidosListController.position.maxScrollExtent);
    pedidosListController.jumpTo(newOffset);
  }

  void _onScrollEnd(DragEndDetails details) {
    double inertiaFactor = 0.1;
    int stopSpeed = 0;

    double scrollVelocity = details.velocity.pixelsPerSecond.dx * inertiaFactor;
    double newOffset = pedidosListController.offset - scrollVelocity;

    newOffset =
        newOffset.clamp(0, pedidosListController.position.maxScrollExtent);

    pedidosListController.animateTo(newOffset,
        duration:
            Duration(milliseconds: 500 - ((stopSpeed.clamp(0, 4) + 1) * 90)),
        curve: Curves.easeOutCubic);
  }
}
