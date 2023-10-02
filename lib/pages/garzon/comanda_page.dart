import 'package:flutter/material.dart';
import 'package:jerupos/pages/garzon/nuevo_pedido_page.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/widgets/pedido_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ComandaPage extends StatefulWidget {
  @override
  State<ComandaPage> createState() => _ComandaPageState();
}

class _ComandaPageState extends State<ComandaPage> {
  bool sortByOrderNumber = true;

  void toggleSort() {
    setState(() {
      sortByOrderNumber = !sortByOrderNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lógica de re-ordenamiento
    // List<Orden> sortedOrders = [...currentOrders];
    // if (sortByOrderNumber) {
    //   sortedOrders.sort((a, b) {
    //     return b.id.compareTo(a.id);
    //   });
    // } else {
    //   sortedOrders.sort((a, b) {
    //     return a.numeroMesa!.compareTo(b.numeroMesa!);
    //   });
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('JeruPOS'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NuevoPedidoPage(),
                      ),
                    );
                  },
                  child: Text("Nuevo Pedido"),
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
            child: FutureBuilder(
              future: PedidoService.list(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PedidoCard(
                        pedido: snapshot.data![index],
                        onButtonPressed: () {
                          // Envía la orden a la página de edición y espera el resultado
                          // final cambiosOrden = Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return EditarPedidoPage(
                          //       pedido: snapshot.data![index]);
                          // }));

                          // // Si recibe un resultado, actualiza la orden
                          // setState(() {
                          //   snapshot.data![index].numeroMesa =
                          //       int.parse(cambiosOrden['numeroMesa']);
                          //   // orden['productos'] = cambiosOrden['productos'];
                          //   // currentOrders[indexOrden] = orden;
                          // });
                        },
                        buttonLabel: "Editar",
                      );
                    },
                  );
                }
              },
            ),
          )
              // !! Este Grid necesita acceso al detalle de la orden.

              // : GridView.builder(
              //     // Muestra las órdenes en formato Grid
              //     padding: EdgeInsets.all(16.0),
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2,
              //       mainAxisSpacing: 16.0,
              //       crossAxisSpacing: 16.0,
              //     ),
              //     itemCount: sortedOrders.length,
              //     itemBuilder: (context, index) {
              //       final orden = sortedOrders[index];
              //       return OrdenCard(
              //         orden: orden,
              //         numeroMesa: orden.numeroMesa.toString(),
              //         onButtonPressed: () async {
              //           // Envía la orden a la página de edición y espera el resultado
              //           // final cambiosOrden = await Navigator.push(context,
              //           //     MaterialPageRoute(builder: (context) {
              //           //   return EditarPedidoPage(orden: orden);
              //           // }));

              //           // Si recibe un resultado, actualiza la orden
              //           // if (cambiosOrden != null) {
              //           //   setState(() {
              //           //     orden.numeroMesa = int.parse(cambiosOrden['numeroMesa']);
              //           //     // orden['productos'] = cambiosOrden['productos'];
              //           //     currentOrders[indexOrden] = orden;
              //           //   });
              //           // }
              //         },
              //         buttonLabel: "Editar",
              //       );
              //     },
              //   ),
              ),
        ],
      ),
    );
  }
}
