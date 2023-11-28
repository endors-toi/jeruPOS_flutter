import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jerupos/models/ingrediente.dart';
import 'package:jerupos/models/producto.dart';
import 'package:jerupos/pages/admin/ingrediente_form_page.dart';
import 'package:jerupos/services/categoria_service.dart';
import 'package:jerupos/services/ingrediente_service.dart';
import 'package:jerupos/services/producto_service.dart';
import 'package:jerupos/utils/mostrar_toast.dart';
import 'package:jerupos/widgets/campo_texto.dart';
import 'package:jerupos/widgets/Ingrediente_producto_tile.dart';
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
  TextEditingController _categoriaController = TextEditingController();
  List<DropdownMenuEntry> _categorias = [];
  List<IngredienteProductoTile> _ingredientes = [];
  Map<int, double> _ingredientesSeleccionados = {};
  int _selectedCategoria = 0;

  Producto? _producto;
  bool _edit = false;

  @override
  void initState() {
    super.initState();
    _loadProducto();
    _loadCategorias();
    _loadIngredientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.id == null
            ? Text('Nuevo producto')
            : Text('Editar producto'),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: _categorias == []
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                      child: DropdownMenu(
                        initialSelection: _edit
                            ? _encontrarIndexCategoria(_selectedCategoria)
                            : null,
                        menuHeight: 235,
                        width: MediaQuery.of(context).size.width - 50,
                        label: Text("Categoria"),
                        dropdownMenuEntries: _categorias,
                        onSelected: (value) {
                          setState(() {
                            _selectedCategoria = int.parse(value);
                          });
                        },
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "Ingredientes",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
            ),
            _ingredientes != []
                ? Column(children: _ingredientes)
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CircularProgressIndicator())),
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
                  ).then((_) => setState(() {
                        _loadIngredientes();
                      }));
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
                  _crearProducto();
                }
              },
              child: Text("Crear Producto"),
            ),
          ]),
        ),
      ),
    );
  }

  bool validateForm() {
    String errores = "";
    if (_nombreController.text == "") {
      errores += "Especifique nombre.";
    }
    if (_abreviacionController.text == "") {
      errores += "La abreviacion no puede estar vacia." +
          (errores.length == 0 ? "" : "\n");
    }
    if (_precioController.text == "") {
      errores += "Debe indicar precio del producto." +
          (errores.length == 0 ? "" : "\n");
    }
    if (_selectedCategoria == 0) {
      errores +=
          "Debe seleccionar una categoria." + (errores.length == 0 ? "" : "\n");
    }
    if (_ingredientesSeleccionados.length == 0) {
      errores += "Debe seleccionar al menos un ingrediente.";
    }
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

  void _loadCategorias() async {
    List<dynamic> categorias = await CategoriaService.list();
    List<DropdownMenuEntry> _tempCategorias = [];
    for (var categoria in categorias) {
      _tempCategorias.add(DropdownMenuEntry(
          label: categoria['nombre'], value: categoria['id'].toString()));
    }
    setState(() {
      _categorias = _tempCategorias;
    });
  }

  void _loadProducto() {
    if (widget.id != null) {
      _edit = true;
      ProductoService.get(widget.id!).then((producto) {
        setState(() {
          this._producto = producto;
          _nombreController.text = producto.nombre;
          _abreviacionController.text = producto.abreviacion;
          _precioController.text = producto.precio.toString();
          _selectedCategoria = producto.categoria;
          print(producto.categoria);
        });
      });
    }
  }

  void _loadIngredientes() async {
    List<Ingrediente> ingredientes = await IngredienteService.list();
    List<IngredienteProductoTile> _tempIngredientes = [];
    for (var ingrediente in ingredientes) {
      _tempIngredientes.add(IngredienteProductoTile(
        ingrediente: ingrediente,
        onSelected: (ingrediente, isChecked) {
          if (isChecked) {
            _ingredientesSeleccionados[ingrediente.id!] = 0;
          } else {
            _ingredientesSeleccionados.remove(ingrediente.id);
          }
          print(_ingredientesSeleccionados);
          setState(() {});
        },
        onCantidadChanged: (cantidad) {
          if (cantidad == null) {
            mostrarToast("Las cantidades deben ser sólo números");
          } else {
            _ingredientesSeleccionados[ingrediente.id!] = cantidad;
          }
          print(_ingredientesSeleccionados);
          setState(() {});
        },
      ));
    }
    setState(() {
      _ingredientes = _tempIngredientes;
    });
  }

  int _encontrarIndexCategoria(int id) {
    return _categorias.indexWhere((cat) => int.parse(cat.value) == id);
  }

  void _crearProducto() {
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

    ProductoService.create(producto).then((value) {
      EasyLoading.showSuccess("Producto creado correctamente");
      Navigator.pop(context);
    }).catchError((error) {
      EasyLoading.showError("Error al crear producto");
    });
  }
}
