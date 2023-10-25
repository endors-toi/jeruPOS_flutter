import 'package:flutter/material.dart';
import 'package:jerupos/models/usuario.dart';
import 'package:jerupos/services/usuario_service.dart';

class UsuarioFormPage extends StatefulWidget {
  final int? id;
  UsuarioFormPage({this.id});

  @override
  _UsuarioFormPageState createState() => _UsuarioFormPageState();
}

class _UsuarioFormPageState extends State<UsuarioFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _editMode = false;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _contrasena2Controller = TextEditingController();
  int? _idRol;

  List<DropdownMenuItem<int>> dropdownMenuEntries = [
    DropdownMenuItem(
      child: Text("Cocina"),
      value: 2,
    ),
    DropdownMenuItem(
      child: Text("Garzón"),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text("Caja"),
      value: 3,
    ),
    DropdownMenuItem(
      child: Text("Administrador"),
      value: 4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _editMode = true;

      UsuarioService.get(widget.id!).then((usuario) {
        setState(() {
          _nombreController.text = usuario.nombre;
          _apellidoController.text = usuario.apellido;
          _emailController.text = usuario.email;
          _idRol = usuario.rol;
        });
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar el usuario: $e')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editMode ? 'Editar Usuario' : 'Nuevo Usuario'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _apellidoController,
                  decoration: InputDecoration(labelText: 'Apellido'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un apellido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contrasenaController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (!_editMode && (value == null || value.isEmpty)) {
                      return 'Por favor ingrese una contraseña';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contrasena2Controller,
                  decoration: InputDecoration(labelText: 'Repite Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (!_editMode && (value == null || value.isEmpty)) {
                      return 'Por favor ingrese una contraseña';
                    }
                    if (value != _contrasenaController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Rol'),
                  items: dropdownMenuEntries,
                  value: _editMode ? _idRol : null,
                  onChanged: (value) {
                    setState(() {
                      _idRol = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor seleccione un rol';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _editMode ? _editarUsuario : _crearUsuario,
                  child: Text(_editMode ? 'Editar Usuario' : 'Crear Usuario'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _crearUsuario() async {
    if (_formKey.currentState!.validate()) {
      try {
        Usuario nuevoUsuario = Usuario(
          nombre: _nombreController.text,
          apellido: _apellidoController.text,
          email: _emailController.text,
          password: _contrasenaController.text,
          password2: _contrasena2Controller.text,
          rol: _idRol!,
        );

        await UsuarioService.create(nuevoUsuario);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario creado exitosamente')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el usuario: $e')),
        );
      }
    }
  }

  void _editarUsuario() async {
    if (_formKey.currentState!.validate()) {
      try {
        Map<String, dynamic> datosEditados = {
          'nombre': _nombreController.text,
          'apellido': _apellidoController.text,
          'email': _emailController.text,
          'rol_id': _idRol,
        };

        if (_contrasenaController.text.isNotEmpty) {
          datosEditados['contrasena'] = _contrasenaController.text;
        }

        await UsuarioService.update(datosEditados, widget.id!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario actualizado exitosamente')),
        );

        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el usuario: $e')),
        );
      }
    }
  }
}
