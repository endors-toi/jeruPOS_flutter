import 'package:flutter/material.dart';
import 'package:jerupos/pages/admin/usuario_form_page.dart';
import 'package:jerupos/services/usuario_service.dart';
import 'package:jerupos/widgets/usuario_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  late Future<List<dynamic>> _usuariosFuture;

  @override
  void initState() {
    super.initState();
    _usuariosFuture = _listUsuarios();
  }

  Future<List<dynamic>> _listUsuarios() async {
    return await UsuarioService.list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Personal'),
            FilledButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsuarioFormPage()),
                );
                setState(() {
                  _usuariosFuture = _listUsuarios();
                });
              },
              child: Icon(MdiIcons.plus),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: FutureBuilder<List<dynamic>>(
          future: _usuariosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var usuario = snapshot.data![index];
                    print(snapshot);
                    return UsuarioTile(
                      id: usuario['id'],
                      nombre: usuario['nombre'],
                      apellido: usuario['apellido'],
                      email: usuario['email'],
                      onActionCompleted: () {
                        setState(() {
                          _usuariosFuture = _listUsuarios();
                        });
                      },
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
