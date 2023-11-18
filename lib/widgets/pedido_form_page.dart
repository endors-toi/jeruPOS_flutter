import 'package:flutter/material.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/models/producto_pedido.dart';
import 'package:jerupos/models/usuario.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/services/producto_service.dart';
import 'package:jerupos/utils/mostrar_snackbar.dart';
import 'package:provider/provider.dart';

class PedidoFormPage extends StatefulWidget {
  final int? id;
  PedidoFormPage({this.id});

  @override
  _PedidoFormPageState createState() => _PedidoFormPageState();
}

class _PedidoFormPageState extends State<PedidoFormPage> {
  late Future _productosFuture;
  Usuario? usuario;
  bool _editMode = false;
  int? mesa = null;
  String? cliente = null;
  List<ProductoPedido> productosPedido = [];
  TextEditingController clienteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productosFuture = ProductoService.list();
    if (widget.id != null) {
      _editMode = true;

      PedidoService.get(widget.id!).then((pedido) {
        setState(() {
          mesa = pedido.mesa;
          productosPedido = pedido.productos!;
        });
      }).catchError((e) {
        mostrarSnackbar(context, 'Error al cargar el pedido: $e');
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      this.usuario =
          Provider.of<UsuarioProvider>(context, listen: false).usuario;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editMode ? 'Editar Pedido' : 'Nuevo Pedido'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: FutureBuilder(
                future: _productosFuture,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<ProductoPedido> productos = snapshot.data!;
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
                          onPressed: () => agregarProducto(productos[index]),
                          child: Text(productos[index].abreviacion ?? 'N/A'),
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
                    child: ListView.builder(
                      itemCount: productosPedido.length,
                      itemBuilder: (context, index) {
                        ProductoPedido producto = productosPedido[index];
                        return ListTile(
                          title:
                              Text('${producto.cantidad} x ${producto.nombre}'),
                          onTap: () {
                            setState(() {
                              eliminarProducto(index);
                            });
                          },
                        );
                      },
                    ),
                  ),
                  usuario == null
                      ? CircularProgressIndicator()
                      : usuario!.rol == 1
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Mesa:  ',
                                  style: TextStyle(fontSize: 18),
                                ),
                                DropdownButton<int>(
                                  value: mesa,
                                  hint: Text("--",
                                      style: TextStyle(fontSize: 24)),
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
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 36, vertical: 8),
                              child: TextFormField(
                                controller: clienteCtrl,
                                decoration: InputDecoration(
                                  hintText: "Nombre cliente",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                  Container(
                    height: 52,
                    margin: EdgeInsets.only(top: 8),
                    width: double.infinity,
                    child: FilledButton(
                      child: Text(_editMode ? 'Editar Pedido' : 'Crear Pedido'),
                      onPressed: () =>
                          _editMode ? editarPedido() : crearPedido(),
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

  void agregarProducto(ProductoPedido producto) {
    setState(() {
      final indexProductoExistente =
          productosPedido.indexWhere((p) => p.id == producto.id);
      if (indexProductoExistente != -1) {
        productosPedido[indexProductoExistente].incrementarCantidad();
      } else {
        productosPedido.add(producto);
      }
    });
  }

  void eliminarProducto(int index) {
    setState(() {
      if (productosPedido[index].cantidad == 1) {
        productosPedido.removeAt(index);
      } else {
        productosPedido[index].decrementarCantidad();
      }
    });
  }

  void crearPedido() async {
    cliente = clienteCtrl.text.trim();
    int? userId = usuario!.id;
    if (userId == null) {
      mostrarSnackbar(context, 'Error al cargar el usuario');
      return;
    }

    Pedido pedido = Pedido(
      idUsuario: userId,
      mesa: mesa != null ? mesa : null,
      nombreCliente: cliente != null ? cliente : null,
      estado: 'PENDIENTE',
      productos: productosPedido,
    );

    await PedidoService.create(pedido);
    Navigator.pop(context);
  }

  void editarPedido() async {
    Pedido pedido = Pedido(
      id: widget.id,
      mesa: mesa,
      productos: productosPedido,
    );

    await PedidoService.updatePATCH(pedido);
    Navigator.pop(context);
  }
}
