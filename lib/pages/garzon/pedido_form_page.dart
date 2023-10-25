import 'package:flutter/material.dart';
import 'package:jerupos/models/pedido.dart';
import 'package:jerupos/models/producto.dart';
import 'package:jerupos/services/auth_service.dart';
import 'package:jerupos/services/pedido_service.dart';
import 'package:jerupos/services/producto_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class PedidoFormPage extends StatefulWidget {
  final int? id;
  PedidoFormPage({this.id});

  @override
  _PedidoFormPageState createState() => _PedidoFormPageState();
}

class _PedidoFormPageState extends State<PedidoFormPage> {
  late Future _productosFuture;
  List<Producto> productosPedido = [];
  bool _editMode = false;
  int? mesa;

  @override
  void initState() {
    super.initState();
    _productosFuture = ProductoService.list();
    if (widget.id != null) {
      _editMode = true;

      PedidoService.get(widget.id!).then((pedido) {
        setState(() {
          mesa = pedido.mesa;
          productosPedido = pedido.productos;
        });
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar el pedido: $e')),
        );
      });
    }
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
                    List<Producto> productos = snapshot.data!;
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
                        Producto producto = productosPedido[index];
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
                      child:
                          Text(_editMode ? 'Editar Pedido' : 'Enviar Pedido'),
                      onPressed: () =>
                          _editMode ? editarPedido() : enviarPedido(),
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

  void agregarProducto(Producto producto) {
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

  void enviarPedido() async {
    int? userId = await _getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar el usuario')),
      );
      return;
    }
    Pedido pedido = Pedido(
      idUsuario: userId,
      mesa: mesa,
      estado: 'PENDIENTE',
      productos: productosPedido,
    );

    await PedidoService.create(pedido);
    Navigator.pop(context);
  }

  void editarPedido() {
    Pedido pedido = Pedido(
      id: widget.id,
      mesa: mesa,
      productos: productosPedido,
    );

    PedidoService.update(pedido);
    Navigator.pop(context);
  }

  Future<int?> _getUserId() async {
    String? token = await AuthService.getAccessToken();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['user_id'];
    } else {
      return null;
    }
  }
}
