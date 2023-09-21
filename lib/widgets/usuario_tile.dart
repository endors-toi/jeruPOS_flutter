import 'package:flutter/material.dart';
import 'package:jerupos/pages/admin/usuario_form_page.dart';
import 'package:jerupos/services/usuario_service.dart';

class UsuarioTile extends StatefulWidget {
  final VoidCallback onActionCompleted;

  final int id;
  final String nombre;
  final String apellido;
  final String nombreUsuario;

  UsuarioTile({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.nombreUsuario,
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
              widget.nombre.substring(0, 1),
            ),
            backgroundColor: Colors.blue,
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.nombre} ${widget.apellido}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '@${widget.nombreUsuario}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UsuarioFormPage(
                            id: this.widget.id,
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
                      '¿Seguro que quieres eliminar el usuario de ${widget.nombre} ${widget.apellido}?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await UsuarioService.deleteUsuario(widget.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Se ha eliminado el usuario de ${widget.nombre} ${widget.apellido}'),
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
