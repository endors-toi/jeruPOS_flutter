import 'package:flutter/material.dart';
import 'package:jerupos/data/models.dart';
import 'package:jerupos/pages/garzon/editar_pedido_page.dart';
import 'package:jerupos/pages/garzon/nuevo_pedido_page.dart';
import 'package:jerupos/widgets/orden_card.dart';
import 'package:jerupos/data/ordenes.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ComandaPage extends StatefulWidget {
  @override
  State<ComandaPage> createState() => _ComandaPageState();
}

class _ComandaPageState extends State<ComandaPage> {
  static int numeroOrden = 0;
  bool sortByOrderNumber = true;

  void toggleSort() {
    setState(() {
      sortByOrderNumber = !sortByOrderNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lógica de re-ordenamiento
    List<Orden> sortedOrders = [...currentOrders];
    if (sortByOrderNumber) {
      sortedOrders.sort((a, b) {
        return b.id.compareTo(a.id);
      });
    } else {
      sortedOrders.sort((a, b) {
        return a.numeroMesa!.compareTo(b.numeroMesa!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Stack(
          alignment: Alignment.centerRight,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Abre página que construye un Nuevo Pedido y espera el resultado
                  // final nuevaOrden = await Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => NuevoPedidoPage(),
                  //   ),
                  // );
                  // Si recibe un resultado, agrega la orden a la lista compartida 'currentOrders' y asigna número de orden
                  // if (nuevaOrden != null) {
                  //   setState(() {
                  //     numeroOrden++;
                  //     nuevaOrden['numeroOrden'] = numeroOrden;
                  //     currentOrders.add(nuevaOrden);
                  //   });
                  // }
                },
                child: Text("Nuevo Pedido"),
              ),
            ),
            IconButton(
              // Botón que alterna entre Orden cronológico y por número de mesa
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
      ),
      body: currentOrders.isEmpty
          ? Center(
              child: Text(
                "Sin pedidos activos",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            )
          : GridView.builder(
              // Muestra las órdenes en formato Grid
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemCount: sortedOrders.length,
              itemBuilder: (context, index) {
                final orden = sortedOrders[index];
                return OrdenCard(
                  orden: orden,
                  numeroMesa: orden.numeroMesa.toString(),
                  onButtonPressed: () async {
                    // Envía la orden a la página de edición y espera el resultado
                    // final cambiosOrden = await Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return EditarPedidoPage(orden: orden);
                    // }));

                    // Si recibe un resultado, actualiza la orden
                    // if (cambiosOrden != null) {
                    //   setState(() {
                    //     orden.numeroMesa = int.parse(cambiosOrden['numeroMesa']);
                    //     // orden['productos'] = cambiosOrden['productos'];
                    //     currentOrders[indexOrden] = orden;
                    //   });
                    // }
                  },
                  buttonLabel: "Editar",
                );
              },
            ),
    );
  }
}
