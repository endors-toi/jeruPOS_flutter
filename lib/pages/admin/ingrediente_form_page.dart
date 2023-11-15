import 'package:flutter/material.dart';
import 'package:jerupos/models/ingrediente.dart';
import 'package:jerupos/services/ingrediente_service.dart';
import 'package:jerupos/utils/mostrar_dialog_simple.dart';
import 'package:jerupos/utils/mostrar_snackbar.dart';

class IngredienteFormPage extends StatefulWidget {
  final int? id;
  IngredienteFormPage({this.id});

  @override
  State<IngredienteFormPage> createState() => _IngredienteFormPageState();
}

class _IngredienteFormPageState extends State<IngredienteFormPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _editMode = false;

  TextEditingController nombreController = TextEditingController();
  TextEditingController cantidadDisponibleController = TextEditingController();
  TextEditingController cantidadCriticaController = TextEditingController();
  TextEditingController unidadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _editMode = true;
      IngredienteService.get(widget.id!).then((ingrediente) {
        setState(() {
          nombreController.text = ingrediente.nombre;
          cantidadDisponibleController.text =
              ingrediente.cantidadDisponible.toString();
          cantidadCriticaController.text =
              ingrediente.cantidadCritica.toString();
          unidadController.text = ingrediente.unidad;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(2),
                    child: Text(
                      _editMode ? "Editar Ingrediente" : "Nuevo Ingrediente",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 16),
                    child: Divider(
                      color: Colors.transparent,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        labelText: "Nombre",
                        labelStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(),
                      ),
                      validator: (nombre) {
                        if (nombre == null || nombre.isEmpty) {
                          return "El nombre es requerido";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTapUp: (_) {
                        if (_editMode) {
                          mostrarDialogSimple(context, "Edición no permitida",
                              "Para ajustar el stock actual de un ingrediente, se debe realizar desde Control de Stock.");
                        }
                      },
                      child: AbsorbPointer(
                        absorbing: _editMode,
                        child: TextFormField(
                          controller: cantidadDisponibleController,
                          enabled: !_editMode,
                          decoration: InputDecoration(
                            labelText:
                                "Stock ${_editMode ? 'Actual' : 'Inicial'}",
                            labelStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (cantidad) {
                            if (cantidad == null || cantidad.isEmpty) {
                              return "Esta cantidad es requerida";
                            }
                            if (int.tryParse(cantidad) == null) {
                              return "Debe ser un número";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: cantidadCriticaController,
                      decoration: InputDecoration(
                        labelText: "Stock Crítico",
                        labelStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (cantidad) {
                        if (cantidad == null || cantidad.isEmpty) {
                          return "Esta cantidad es requerida";
                        }
                        if (int.tryParse(cantidad) == null) {
                          return "Debe ser un número";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: unidadController,
                      decoration: InputDecoration(
                        labelText: "Unidad de Medida",
                        labelStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(),
                      ),
                      validator: (unidad) {
                        if (unidad == null || unidad.isEmpty) {
                          return "La unidad es requerida";
                        }
                        if (unidad.length > 10) {
                          return "La unidad debe tener menos de 10 caracteres";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    child: SizedBox(
                      height: 50,
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 8),
                      child: FilledButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(18),
                          minimumSize: MaterialStateProperty.all(Size(0, 50)),
                        ),
                        child: Text(
                          _editMode ? "EDITAR" : "CREAR",
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Ingrediente ingrediente = Ingrediente(
                              nombre: nombreController.text,
                              cantidadDisponible:
                                  int.parse(cantidadDisponibleController.text),
                              cantidadCritica:
                                  int.parse(cantidadCriticaController.text),
                              unidad: unidadController.text,
                            );
                            if (_editMode) {
                              // parche porque PUT no funciona en el backend
                              Map<String, dynamic> ingr = {
                                "nombre": ingrediente.nombre,
                                "cantidad_critica": ingrediente.cantidadCritica,
                                "unidad": ingrediente.unidad,
                              };
                              IngredienteService.patch(ingr, widget.id!)
                                  .then((value) {
                                mostrarSnackbar(context, "Ingrediente editado");
                                Navigator.pop(context);
                              });
                            } else {
                              IngredienteService.create(ingrediente)
                                  .then((value) {
                                mostrarSnackbar(context, "Ingrediente creado");
                                Navigator.pop(context);
                              });
                            }
                          }
                        },
                      )),
                  Container(
                      width: double.infinity,
                      child: OutlinedButton(
                        child: Text("CANCELAR"),
                        onPressed: () => Navigator.pop(context),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
