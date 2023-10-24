import 'package:flutter/material.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/pages/garzon/pedido_form_page.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/widgets/error_retry_widget.dart';
import 'package:jerupos/widgets/pedido_card.dart';
import 'package:jerupos/widgets/user_drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GarzonPage extends StatefulWidget {
  @override
  State<GarzonPage> createState() => _GarzonPageState();
}

class _GarzonPageState extends State<GarzonPage> {
  bool sortByOrderNumber = true;
  List<Pedido> pedidos = [];
  List<Pedido> pedidosActivos = [];
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  void _loadPedidos() {
    PedidoService.list().then((value) {
      setState(() {
        pedidos.addAll(value);
        pedidosActivos =
            pedidos.where((pedido) => pedido.estado != 'PAGADO').toList();
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
      sortByOrderNumber = !sortByOrderNumber;
      pedidosActivos.sort((a, b) {
        if (sortByOrderNumber) {
          return (b.id ?? 0).compareTo(a.id ?? 0);
        } else {
          return (a.mesa ?? 0).compareTo(b.mesa ?? 0);
        }
      });
    });
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
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PedidoFormPage(),
                              ),
                            );
                            if (result != null && result == 'refresh') {
                              setState(() {});
                            }
                          },
                          child: Text("Nuevo Pedido"),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        sortByOrderNumber
                            ? MdiIcons.sortClockAscendingOutline
                            : MdiIcons.sortNumericAscending,
                        size: 32,
                      ),
                      onPressed: toggleSort,
                    ),
                  ],
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: (pedidosActivos.length + 1) ~/ 2,
                    itemBuilder: (BuildContext context, int index) {
                      int leftCardIndex = index * 2;
                      int rightCardIndex = index * 2 + 1;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: PedidoCard(
                              pedido: pedidosActivos[leftCardIndex],
                              onTap: (TapUpDetails details) async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PedidoFormPage(
                                        id: pedidosActivos[leftCardIndex].id),
                                  ),
                                );
                                if (result == 'refresh') {
                                  setState(() {});
                                }
                              },
                              buttonLabel: Text("Editar"),
                            ),
                          ),
                          rightCardIndex >= pedidosActivos.length
                              ? Expanded(flex: 1, child: SizedBox())
                              : Expanded(
                                  flex: 1,
                                  child: PedidoCard(
                                    pedido: pedidosActivos[rightCardIndex],
                                    onTap: (TapUpDetails details) async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PedidoFormPage(
                                              id: pedidosActivos[rightCardIndex]
                                                  .id),
                                        ),
                                      );
                                      if (result == 'refresh') {
                                        setState(() {});
                                      }
                                    },
                                    buttonLabel: Text("Editar"),
                                  ),
                                ),
                        ],
                      );
                    },
                  ),
                )),
              ],
            ),
    );
  }
}
