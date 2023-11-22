import 'package:flutter/material.dart';
import 'package:jerupos/pages/admin/producto_form_page.dart';
import 'package:jerupos/services/producto_service.dart';
import 'package:jerupos/utils/mostrar_snackbar.dart';
import 'package:jerupos/widgets/producto_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProductosPage extends StatefulWidget {
  @override
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProductoFormPage();
                  })).then((_) => setState(() {}));
                },
              ),
            ),
          ]),
      body: FutureBuilder(
        future: ProductoService.list(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var producto = snapshot.data[index];
                return ProductoTile(
                  producto: producto,
                  onTapUp: (_) => _onTapOptions(producto.id!),
                );
              },
            );
          }
        },
      ),
    );
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
                  })).then((_) => setState(() {}));
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
                          title: Text('Eliminar Ingrediente'),
                          content: Text(
                              '¿Está seguro que desea eliminar este ingrediente?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // ProductoService.delete(id).then((_) {
                                //   setState(() {});
                                //   mostrarSnackbar(
                                //       context, 'Ingrediente eliminado');
                                // });
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
}
