import 'package:flutter/material.dart';
import 'package:jerupos/pages/garzon/pedido_form_page.dart';
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
    // Lógica de re-ordenamiento PENDIENTE

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
                        onButtonPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PedidoFormPage(
                                  id: snapshot.data![index]['id']),
                            ),
                          );
                          if (result != null && result == 'refresh') {
                            setState(() {});
                          }
                        },
                        buttonLabel: "Editar",
                      );
                    },
                  );
                }
              },
            ),
          )),
        ],
      ),
    );
  }
}
