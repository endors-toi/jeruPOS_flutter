import 'package:flutter/material.dart';
import 'package:jerupos/models/ingrediente.dart';
import 'package:jerupos/services/ingrediente_service.dart';
import 'package:jerupos/pages/admin/ingrediente_form_page.dart';
import 'package:jerupos/utils/mostrar_snackbar.dart';
import 'package:jerupos/widgets/ingrediente_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class IngredientesPage extends StatefulWidget {
  @override
  _IngredientesPageState createState() => _IngredientesPageState();
}

class _IngredientesPageState extends State<IngredientesPage> {
  late Future<List<Ingrediente>> _ingredientesFuture;

  @override
  void initState() {
    super.initState();
    _ingredientesFuture = _listIngredientes();
  }

  Future<List<Ingrediente>> _listIngredientes() async {
    return await IngredienteService.list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Ingredientes'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: ElevatedButton(
                child: Icon(MdiIcons.plus, size: 28),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return IngredienteFormPage();
                  })).then((value) => setState(() {
                        _ingredientesFuture = _listIngredientes();
                      }));
                },
              ),
            ),
          ]),
      body: FutureBuilder(
        future: _ingredientesFuture,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var ingrediente = snapshot.data[index];
                return IngredienteTile(
                    ingrediente: ingrediente,
                    onTapUp: (_) => _onTapOptions(ingrediente.id!));
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
                    return IngredienteFormPage(id: id);
                  })).then((value) => setState(() {
                        _ingredientesFuture = _listIngredientes();
                      }));
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
                              onPressed: () async {
                                Navigator.pop(context);
                                try {
                                  await IngredienteService.delete(id).then((_) {
                                    setState(() {
                                      _ingredientesFuture = _listIngredientes();
                                    });
                                    mostrarSnackbar(
                                        context, 'Ingrediente eliminado');
                                  });
                                } catch (e) {
                                  mostrarSnackbar(context,
                                      'No se puede eliminar el ingrediente');
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
}
