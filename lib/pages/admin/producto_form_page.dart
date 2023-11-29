import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jerupos/models/ingrediente.dart';
import 'package:jerupos/models/producto.dart';
import 'package:jerupos/pages/admin/ingrediente_form_page.dart';
import 'package:jerupos/services/categoria_service.dart';
import 'package:jerupos/services/ingrediente_service.dart';
import 'package:jerupos/services/producto_service.dart';
import 'package:jerupos/widgets/campo_texto.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProductoFormPage extends StatefulWidget {
  final int? id;

  ProductoFormPage({this.id});

  @override
  State<ProductoFormPage> createState() => _ProductoFormPageState();
}

class _ProductoFormPageState extends State<ProductoFormPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _abreviacionController = TextEditingController();
  TextEditingController _precioController = TextEditingController();
  Map<int, TextEditingController> _cantidadesControllers = {};
  Map<int, double> _ingredientesSeleccionados = {};
  int _selectedCategoria = 0;

  Producto? _producto;
  bool _edit = false;

  @override
  void initState() {
    super.initState();
    _loadProducto();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _abreviacionController.dispose();
    _precioController.dispose();
    _cantidadesControllers.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_edit ? 'Editar producto' : 'Nuevo producto'),
        actions: [
          InkWell(child: Icon(MdiIcons.refresh), onTap: () => setState(() {}))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CampoTexto(
                    label: "Nombre",
                    controller: _nombreController,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: CampoTexto(
                    label: "Abreviación",
                    controller: _abreviacionController,
                  ),
                ),
              ],
            ),
            CampoTexto(
              label: "Precio",
              controller: _precioController,
            ),
            FutureBuilder(
                future: CategoriaService.list(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    List<dynamic> categorias = snapshot.data;
                    List<DropdownMenuItem<int>> items = categorias
                        .map((categoria) => DropdownMenuItem<int>(
                            value: categoria["id"],
                            child: Text(categoria["nombre"])))
                        .toList();
                    items.add(DropdownMenuItem<int>(
                        value: 0, child: Text("Seleccione una categoría")));
                    return DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: "Categoría",
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedCategoria,
                      items: items,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoria = value ?? 0;
                        });
                      },
                    );
                  }
                }),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "Ingredientes",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
            ),
            FutureBuilder(
              future: IngredienteService.list(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  List<Ingrediente> ingredientes =
                      snapshot.data as List<Ingrediente>;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ingredientes.length,
                    itemBuilder: (context, index) {
                      Ingrediente ingrediente = ingredientes[index];
                      bool isSelected = _ingredientesSeleccionados
                          .containsKey(ingrediente.id);
                      _cantidadesControllers.putIfAbsent(
                          ingrediente.id!,
                          () => TextEditingController(
                              text: isSelected
                                  ? _formatoNumero(_ingredientesSeleccionados[
                                      ingrediente.id!])
                                  : ""));
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _ingredientesSeleccionados.remove(ingrediente.id);
                            } else {
                              _ingredientesSeleccionados[ingrediente.id!] = 1;
                            }
                          });
                        },
                        child: ListTile(
                          tileColor: isSelected
                              ? Colors.orangeAccent.withOpacity(0.4)
                              : null,
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(ingrediente.nombre),
                              ),
                              Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      _ingredientesSeleccionados[
                                          ingrediente.id!] = 0;
                                    } else {
                                      _ingredientesSeleccionados
                                          .remove(ingrediente.id);
                                    }
                                  });
                                },
                              ),
                              if (isSelected)
                                Flexible(
                                  child: TextFormField(
                                    controller:
                                        _cantidadesControllers[ingrediente.id!],
                                    decoration: InputDecoration(
                                      labelText: 'Cantidad',
                                      border: OutlineInputBorder(),
                                      suffixText: ingrediente.unidad,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        double? quantity =
                                            double.tryParse(value);
                                        if (quantity != null) {
                                          _ingredientesSeleccionados[
                                              ingrediente.id!] = quantity;
                                        }
                                      }
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.orangeAccent.withOpacity(0.4),
              ),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 50),
              height: 40,
              alignment: Alignment.center,
              child: InkWell(
                child: Text(
                  "Agregar ingrediente",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IngredienteFormPage(),
                    ),
                  ).then((value) => setState(() {}));
                },
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                elevation: 10,
                minimumSize: Size(0, 50),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                if (validateForm()) {
                  _edit ? _editarProducto() : _crearProducto();
                }
              },
              child: Text(_edit ? "Editar Producto" : "Crear Producto"),
            ),
          ]),
        ),
      ),
    );
  }

  bool validateForm() {
    String errores = "";
    if (_nombreController.text == "") {
      errores += "Especifique nombre.\n";
    }
    if (_abreviacionController.text == "") {
      errores += "La abreviacion no puede estar vacía." +
          (errores.length == 0 ? "" : "\n");
    }
    if (_precioController.text == "") {
      errores += "Debe indicar precio del producto." +
          (errores.length == 0 ? "" : "\n");
    } else if (double.tryParse(_precioController.text) == null) {
      errores +=
          "El precio debe ser un número." + (errores.length == 0 ? "" : "\n");
    }
    if (_selectedCategoria == 0) {
      errores +=
          "Debe seleccionar una categoría." + (errores.length == 0 ? "" : "\n");
    }
    if (_ingredientesSeleccionados.length == 0) {
      errores += "Debe seleccionar al menos un ingrediente.";
    }
    _cantidadesControllers.forEach((ingredienteId, controller) {
      if (_ingredientesSeleccionados.containsKey(ingredienteId)) {
        if (controller.text == "") {
          errores +=
              "Debe indicar la cantidad de los ingredientes seleccionados.\n";
        } else if (double.tryParse(controller.text) == null) {
          errores += "La cantidad del ingrediente " +
              ingredienteId.toString() +
              " debe ser un número.\n";
        }
      }
    });
    if (errores != "") {
      EasyLoading.showError(
        errores,
        duration: Duration(seconds: 4),
        dismissOnTap: true,
      );
      return false;
    }
    return true;
  }

  void _loadProducto() {
    if (widget.id != null) {
      _edit = true;
      ProductoService.get(widget.id!).then((producto) {
        setState(() {
          this._producto = producto;
          _nombreController.text = producto.nombre.trim();
          _abreviacionController.text =
              producto.abreviacion.trim().toUpperCase();
          _precioController.text = producto.precio.toString();
          _selectedCategoria = producto.categoria;
          for (int i = 0; i < producto.ingredientes!.length; i++) {
            _ingredientesSeleccionados[producto.ingredientes![i].ingrediente] =
                producto.ingredientes![i].cantidad;
            _cantidadesControllers[producto.ingredientes![i].ingrediente] =
                TextEditingController(
                    text: _formatoNumero(producto.ingredientes![i].cantidad));
          }
        });
      });
    }
  }

  String _formatoNumero(double? valor) {
    return valor != null
        ? valor % 1 == 0
            ? valor.toInt().toString()
            : valor.toString()
        : "";
  }

  Map<String, dynamic> _armarProducto() {
    List<int> ingredientes = [];
    List<double> cantidades = [];
    _ingredientesSeleccionados.forEach((key, value) {
      ingredientes.add(key);
      cantidades.add(value);
    });
    Map<String, dynamic> producto = {
      "nombre": _nombreController.text.trim(),
      "abreviacion": _abreviacionController.text.trim().toUpperCase(),
      "precio": int.parse(_precioController.text),
      "categoria": _selectedCategoria,
      "ingredientes": ingredientes,
      "cantidades": cantidades,
    };
    return producto;
  }

  _crearProducto() {
    Map<String, dynamic> producto = _armarProducto();
    ProductoService.create(producto).then((value) {
      EasyLoading.showSuccess("Producto creado correctamente");
      Navigator.pop(context);
    }).catchError((error) {
      EasyLoading.showError("Error al crear producto");
    });
  }

  _editarProducto() {
    Map<String, dynamic> producto = _armarProducto();
    ProductoService.update(producto, _producto!.id!).then((value) {
      EasyLoading.showSuccess("Producto editado correctamente");
      Navigator.pop(context);
    }).catchError((error) {
      EasyLoading.showError("Error al editar producto");
    });
  }
}
