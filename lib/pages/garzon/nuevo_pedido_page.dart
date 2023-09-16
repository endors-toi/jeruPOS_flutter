import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NuevoPedidoPage extends StatefulWidget {
  @override
  _NuevoPedidoPageState createState() => _NuevoPedidoPageState();
}

class _NuevoPedidoPageState extends State<NuevoPedidoPage> {
  final List<String> productos = [
    "GM",
    "GP",
    "GF",
    "GC",
    "GK",
    "½M",
    "½P",
    "½F",
    "½C",
    "½K",
    "MIX",
    "Tx2"
  ];
  final Map<String, int> productosSeleccionados = {};
  String mesa = '1';

  void addProducto(String producto) {
    setState(() {
      productosSeleccionados[producto] =
          (productosSeleccionados[producto] ?? 0) + 1;
    });
  }

  void enviarPedido() {
    final nuevaOrden = {
      'numeroMesa': mesa,
      'paraServir': true,
      'horaPedido': DateFormat('HH:mm').format(DateTime.now()),
      'productos': productosSeleccionados.entries
          .map((e) => '${e.value} x ${e.key}')
          .toList(),
    };
    Navigator.pop(context, nuevaOrden);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisExtent: 50,
                ),
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero))),
                    onPressed: () => addProducto(productos[index]),
                    child: Text(productos[index]),
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text('Pedido:'),
                  Expanded(
                    flex: 3,
                    child: ListView(
                      children: productosSeleccionados.entries.map((entry) {
                        return ListTile(
                          title: Text('${entry.value} x ${entry.key}'),
                          onTap: () {
                            setState(() {
                              if (productosSeleccionados[entry.key]! > 1) {
                                productosSeleccionados[entry.key] =
                                    productosSeleccionados[entry.key]! - 1;
                              } else {
                                productosSeleccionados.remove(entry.key);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mesa:  ',
                        style: TextStyle(fontSize: 24),
                      ),
                      DropdownButton(
                        value: mesa,
                        items:
                            List.generate(10, (index) => (index + 1).toString())
                                .map<DropdownMenuItem<String>>((String valor) {
                          return DropdownMenuItem<String>(
                            value: valor,
                            child: Text(valor),
                          );
                        }).toList(),
                        onChanged: (String? valor) {
                          setState(() {
                            mesa = valor!;
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                    height: 52,
                    margin: EdgeInsets.only(top: 8),
                    width: double.infinity,
                    child: FilledButton(
                      child: Text('Enviar Pedido'),
                      onPressed: () => enviarPedido(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
