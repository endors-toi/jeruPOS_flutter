import 'package:flutter/material.dart';
import 'package:jerupos/models/animations.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/pages/cocina/reporte_diario.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/utils/error_retry.dart';
import 'package:jerupos/utils/mostrar_snackbar.dart';
import 'package:jerupos/widgets/pedido_card.dart';
import 'package:jerupos/widgets/usuario_drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CocinaPage extends StatefulWidget {
  @override
  State<CocinaPage> createState() => _CocinaPageState();
}

class _CocinaPageState extends State<CocinaPage> with TickerProviderStateMixin {
  late AnimatedEllipsisProvider _ellipsisProvider;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late WebSocketChannel _channel;
  ScrollController _pedidosListController = ScrollController(
    initialScrollOffset: 0,
    keepScrollOffset: true,
  );
  String errorMsg = '';

  List<Pedido> pedidos = [];
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

  void _initWebSocket() {
    _channel = PedidoService.connect();
    _channel.stream.listen((event) {
      switch (event['action']) {
        case 'create':
          Pedido pedido = Pedido.fromJson(event);
          Provider.of<PedidoProvider>(context, listen: false).addPedido(pedido);
          break;
        case 'update':
          Pedido pedido = Pedido.fromJson(event);
          Provider.of<PedidoProvider>(context, listen: false)
              .updatePedido(pedido);
          break;
        case 'delete':
          Provider.of<PedidoProvider>(context, listen: false)
              .deletePedido(event['id']);
          break;
        default:
          mostrarSnackbar(context, 'Acción desconocida: ${event['action']}');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initWebSocket();
    _loadPedidos();
    _ellipsisProvider = AnimatedEllipsisProvider(this);
  }

  @override
  void dispose() {
    _pedidosListController.dispose();
    _ellipsisProvider.dispose();
    _channel.sink.close();
    super.dispose();
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
                  : AnimatedList(
                      key: _listKey,
                      controller: _pedidosListController,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      initialItemCount: pedidos.length,
                      itemBuilder:
                          (BuildContext context, int index, animation) {
                        Pedido pedido = pedidos[index];
                        return PedidoCard(pedido: pedido);
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
}
