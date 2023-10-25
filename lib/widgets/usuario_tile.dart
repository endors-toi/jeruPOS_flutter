import 'package:flutter/material.dart';
import 'package:jerupos/models/usuario.dart';
import 'package:jerupos/pages/admin/usuario_form_page.dart';
import 'package:jerupos/services/usuario_service.dart';

class UsuarioTile extends StatefulWidget {
  final VoidCallback onActionCompleted;

  final Usuario usuario;

  UsuarioTile({
    required this.usuario,
    required this.onActionCompleted,
  });

  @override
  State<UsuarioTile> createState() => _UsuarioTileState();
}

class _UsuarioTileState extends State<UsuarioTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Text(
              widget.usuario.nombre.substring(0, 1),
            ),
            backgroundColor: Color.fromARGB(255, 0, 255, 149),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.usuario.nombre} ${widget.usuario.apellido}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.usuario.email}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UsuarioFormPage(
                            id: this.widget.usuario.id,
                          )));
              widget.onActionCompleted();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Eliminar'),
                  content: Text(
                      '¿Seguro que quieres eliminar el usuario de ${widget.usuario.nombre} ${widget.usuario.apellido}?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await UsuarioService.delete(widget.usuario.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Se ha eliminado el usuario de ${widget.usuario.nombre} ${widget.usuario.apellido}'),
                          ),
                        );
                        widget.onActionCompleted();
                        Navigator.pop(context);
                      },
                      child: Text('Eliminar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
