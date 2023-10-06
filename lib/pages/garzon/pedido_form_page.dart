import 'package:flutter/material.dart';
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
  final List<Map<String, dynamic>> productosPedido = [];
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
          mesa = pedido['mesa'];
          pedido['productos'].forEach((producto) {
            productosPedido.add({
              'id': producto['producto'],
              'nombre': producto['nombre'],
              'cantidad': producto['cantidad']
            });
          });
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
                          onPressed: () => agregarProducto(
                              productos[index]['id'],
                              productos[index]['nombre']),
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
                    child: ListView.builder(
                      itemCount: productosPedido.length,
                      itemBuilder: (context, index) {
                        final producto = productosPedido[index];
                        return ListTile(
                          title: Text(
                              '${producto['cantidad']} x ${producto['nombre']}'),
                          onTap: () {
                            setState(() {
                              eliminarProducto(producto['id']);
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

  void agregarProducto(int id, String nombre) {
    setState(() {
      var productoExistente = productosPedido
          .firstWhere((element) => element['id'] == id, orElse: () => {});

      if (productoExistente.isNotEmpty) {
        productoExistente['cantidad']++;
      } else {
        productosPedido.add({'id': id, 'nombre': nombre, 'cantidad': 1});
      }
    });
  }

  void eliminarProducto(int id) {
    setState(() {
      var productoExistente = productosPedido
          .firstWhere((element) => element['id'] == id, orElse: () => {});

      if (productoExistente.isNotEmpty && productoExistente['cantidad'] > 1) {
        productoExistente['cantidad']--;
      } else {
        productosPedido.remove(productoExistente);
      }
    });
  }

  void enviarPedido() async {
    Map<String, dynamic> pedido = {
      'usuario': await _getUserId(),
      'mesa': mesa,
      'estado': 'PENDIENTE',
      'productos_post': productosPedido,
    };

    await PedidoService.create(pedido);
    Navigator.pop(context, 'refresh');
  }

  void editarPedido() {
    Map<String, dynamic> pedido = {
      'id': widget.id,
      'mesa': mesa,
      'productos_post': productosPedido,
    };

    PedidoService.updatePATCH(pedido);
    Navigator.pop(context, 'refresh');
  }

  Future<int?> _getUserId() async {
    String? token = await AuthService.getToken();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['user_id'];
    } else {
      return null;
    }
  }
}
