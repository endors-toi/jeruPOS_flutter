import 'package:flutter/material.dart';
import 'package:jerupos/models/producto.dart';
import 'package:jerupos/pages/admin/producto_form_page.dart';
import 'package:jerupos/services/categoria_service.dart';
import 'package:jerupos/services/producto_service.dart';
import 'package:jerupos/utils/mostrar_snackbar.dart';
import 'package:jerupos/widgets/producto_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProductosPage extends StatefulWidget {
  @override
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  Map<int, String> _categorias = {};
  Map<int, List<Producto>> _productosPorCategoria = {};
  TextEditingController _nuevaCategoriaController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadCategorias();
    _loadProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Productos'),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: ElevatedButton(
                  child: Icon(MdiIcons.plus, size: 28),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductoFormPage();
                    })).then((_) => setState(() {}));
                  },
                ),
              ),
            ]),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _categorias.length,
                itemBuilder: (context, index) {
                  var categoria = _categorias.keys.elementAt(index);
                  var productos = _productosPorCategoria[categoria];
                  return ExpansionTile(
                    title: Text(_categorias[categoria]!),
                    initiallyExpanded: true,
                    children: [
                      productos != null && productos.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: productos.length,
                              itemBuilder: (context, index) {
                                var producto =
                                    _productosPorCategoria[categoria]![index];
                                return ProductoTile(
                                  producto: producto,
                                  onTapUp: (_) => _onTapOptions(producto.id!),
                                );
                              },
                            )
                          : ListTile(
                              title: Column(
                                children: [
                                  Text('No hay productos en esta categoría'),
                                  ElevatedButton(
                                    child: Text("Eliminar Categoría"),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Eliminar Categoría'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      '¿Está seguro que desea eliminar esta categoría?\n'),
                                                  Text(
                                                    _categorias[categoria]!,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    try {
                                                      await CategoriaService
                                                              .delete(_categorias
                                                                  .keys
                                                                  .elementAt(
                                                                      index))
                                                          .then((_) {
                                                        setState(() {
                                                          _loadCategorias();
                                                        });
                                                        mostrarSnackbar(context,
                                                            'Categoría eliminada');
                                                      });
                                                    } catch (e) {
                                                      mostrarSnackbar(context,
                                                          "No se puede eliminar la categoría");
                                                    }
                                                  },
                                                  child: Text('Eliminar'),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                  )
                                ],
                              ),
                            )
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text("Nueva Categoría"),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(8),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Nueva Categoría'),
                          content: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _nuevaCategoriaController,
                              decoration: InputDecoration(
                                labelText: 'Nombre',
                                border: OutlineInputBorder(),
                              ),
                              validator: ((nombre) {
                                if (nombre == null || nombre.isEmpty) {
                                  return 'El nombre no puede estar vacío';
                                }
                                if (nombre.length > 20) {
                                  return 'El nombre no puede tener más de 20 caracteres';
                                }
                                if (nombre.length < 3) {
                                  return 'El nombre debería tener por lo menos 3 caracteres';
                                }
                                return null;
                              }),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await CategoriaService.create({
                                      'nombre': _nuevaCategoriaController.text
                                    }).then((_) {
                                      _loadCategorias();
                                      mostrarSnackbar(
                                          context, 'Categoría creada');
                                    });
                                  } catch (e) {
                                    mostrarSnackbar(context,
                                        "No se puede crear la categoría");
                                  }
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Crear'),
                            ),
                          ],
                        );
                      });
                },
              ),
            )
          ],
        ));
  }

  void _onTapOptions(int id) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Editar'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProductoFormPage(id: id);
                  })).then((_) {
                    _loadProductos();
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Eliminar'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Eliminar Producto'),
                          content: Text(
                              '¿Está seguro que desea eliminar este producto?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                try {
                                  await ProductoService.delete(id).then((_) {
                                    _loadProductos();
                                    mostrarSnackbar(
                                        context, 'Producto eliminado');
                                  });
                                } catch (e) {
                                  mostrarSnackbar(context,
                                      "No se puede eliminar el producto");
                                }
                              },
                              child: Text('Eliminar'),
                            ),
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _loadCategorias() async {
    _categorias = {};
    await CategoriaService.list().then((categorias) {
      for (var categoria in categorias) {
        _categorias[categoria['id']] = categoria['nombre'];
      }
    });
    setState(() {});
  }

  void _loadProductos() async {
    _productosPorCategoria = {};
    await ProductoService.list().then((productos) {
      for (var producto in productos) {
        if (_productosPorCategoria.containsKey(producto.categoria)) {
          _productosPorCategoria[producto.categoria]!.add(producto);
        } else {
          _productosPorCategoria[producto.categoria] = [producto];
        }
      }
    });
    setState(() {});
  }
}
