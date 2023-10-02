import 'package:flutter/material.dart';
import 'package:jerupos/services/producto_service.dart';

class NuevoPedidoPage extends StatefulWidget {
  @override
  _NuevoPedidoPageState createState() => _NuevoPedidoPageState();
}

class _NuevoPedidoPageState extends State<NuevoPedidoPage> {
  final Map<String, int> productosSeleccionados = {};
  int mesa = 1;

  void addProducto(String producto) {
    setState(() {
      productosSeleccionados[producto] =
          (productosSeleccionados[producto] ?? 0) + 1;
    });
  }

  void enviarPedido() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: FutureBuilder(
                future: ProductoService.list(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<dynamic> productos = snapshot.data!;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisExtent: 50,
                      ),
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        return ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero))),
                          onPressed: () =>
                              addProducto(productos[index]['abreviacion']),
                          child: Text(productos[index]['abreviacion']),
                        );
                      },
                    );
                  }
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
                      DropdownButton<int>(
                        value: mesa,
                        items: List.generate(10, (index) => index + 1)
                            .map<DropdownMenuItem<int>>((int valor) {
                          return DropdownMenuItem<int>(
                            value: valor,
                            child: Text(valor.toString()),
                          );
                        }).toList(),
                        onChanged: (int? valor) {
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
