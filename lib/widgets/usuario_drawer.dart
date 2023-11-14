import 'package:flutter/material.dart';
import 'package:jerupos/models/usuario.dart';
import 'package:jerupos/pages/cocina/historial_page.dart';
import 'package:jerupos/pages/login_page.dart';
import 'package:jerupos/services/auth_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class UsuarioDrawer extends StatefulWidget {
  @override
  State<UsuarioDrawer> createState() => _UsuarioDrawerState();
}

class _UsuarioDrawerState extends State<UsuarioDrawer> {
  Usuario? usuario;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      this.usuario = Provider.of<UsuarioProvider>(context).usuario;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [
              usuario == null
                  ? CircularProgressIndicator()
                  : DrawerHeader(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 0, 255, 145)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40.0,
                            child: Text(
                              '${usuario!.nombre[0].toUpperCase()}',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${usuario!.nombre} ${usuario!.apellido} (${usuario!.rol})',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
              ListTile(
                leading: Icon(MdiIcons.history),
                title: Text('Historial de Pedidos'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HistorialPage()));
                },
              ),
            ]),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              AuthService.logout().then(
                (value) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route route) => false);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
