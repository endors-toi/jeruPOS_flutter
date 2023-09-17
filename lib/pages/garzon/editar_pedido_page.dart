import 'package:flutter/material.dart';

class EditarPedidoPage extends StatefulWidget {
  final Map<String, dynamic> orden;
  EditarPedidoPage({required this.orden});

  @override
  _EditarPedidoPageState createState() => _EditarPedidoPageState();
}

class _EditarPedidoPageState extends State<EditarPedidoPage> {
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
  String mesa = '';

  @override
  void initState() {
    // Inicializa el Widget con información existente de la orden
    super.initState();
    for (var producto in widget.orden['productos']) {
      final cantidad = int.parse(producto.split(' ')[0]);
      final nombre = producto.split(' ')[2];
      productosSeleccionados[nombre] = cantidad;
    }
    mesa = widget.orden['numeroMesa'];
  }

  void addProducto(String producto) {
    setState(() {
      productosSeleccionados[producto] =
          (productosSeleccionados[producto] ?? 0) + 1;
    });
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
                              // Manejo de cantidades de productos
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
                            // Genera una lista de 10 strings del 1 al 10 y los convierte en DropdownMenuItems
                            List.generate(10, (index) => (index + 1).toString())
                                .map<DropdownMenuItem<String>>((String valor) {
                          return DropdownMenuItem<String>(
                              value: valor, child: Text(valor));
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
                      child: Text('Actualizar Pedido'),
                      onPressed: () {
                        // Envía un Map con los cambios realizados a la orden
                        final cambiosOrden = {
                          'numeroMesa': mesa,
                          'productos': productosSeleccionados.entries
                              .map((e) => '${e.value} x ${e.key}')
                              .toList(),
                        };
                        Navigator.pop(context, cambiosOrden);
                      },
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
