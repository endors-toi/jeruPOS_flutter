import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/utils/mostrar_toast.dart';
import 'package:jerupos/widgets/pedido_form_page.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/utils/error_retry.dart';
import 'package:jerupos/widgets/pedido_card.dart';
import 'package:jerupos/widgets/usuario_drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GarzonPage extends StatefulWidget {
  @override
  State<GarzonPage> createState() => _GarzonPageState();
}

class _GarzonPageState extends State<GarzonPage> with TickerProviderStateMixin {
  bool ordenarPorNumOrden = true;
  List<Pedido> pedidos = [];
  List<Pedido> pedidosActivos = [];
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    _setOrientation();
    _initializePedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JeruPOS'),
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
                                _initializePedidos();
                              });
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
                          child: Text(
                            'No hay pedidos activos',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        )
                      : MasonryGridView.builder(
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

  void _initializePedidos() async {
    await PedidoService.list().then((value) {
      setState(() {
        pedidos.addAll(value);
        pedidosActivos = pedidos
            .where((pedido) => pedido.estado != 'PAGADO' && pedido.mesa != null)
            .toList();
        pedidosActivos.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
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
    mostrarToast("Ordenar por ${ordenarPorNumOrden ? 'tiempo' : 'mesa'}");
  }

  void _setOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
