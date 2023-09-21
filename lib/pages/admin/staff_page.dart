import 'package:flutter/material.dart';
import 'package:jerupos/models/usuario.dart';
import 'package:jerupos/pages/admin/usuario_form_page.dart';
import 'package:jerupos/services/usuario_service.dart';
import 'package:jerupos/widgets/usuario_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class StaffPage extends StatefulWidget {
  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  late Future<List<dynamic>> _usuariosFuture;

  @override
  void initState() {
    super.initState();
    _usuariosFuture = _getUsuarios();
  }

  Future<List<dynamic>> _getUsuarios() async {
    return await UsuarioService.getUsuarios();
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
                  _usuariosFuture = _getUsuarios();
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    Usuario usuario = snapshot.data![index];
                    return UsuarioTile(
                      id: usuario.id!,
                      nombre: usuario.nombre,
                      apellido: usuario.apellido,
                      nombreUsuario: usuario.nombreUsuario!,
                      onActionCompleted: () {
                        setState(() {
                          _usuariosFuture = _getUsuarios();
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
