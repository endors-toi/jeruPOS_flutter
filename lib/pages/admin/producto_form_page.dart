import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jerupos/models/ingrediente.dart';
import 'package:jerupos/models/producto.dart';
import 'package:jerupos/services/categoria_service.dart';
import 'package:jerupos/services/ingrediente_service.dart';
import 'package:jerupos/services/producto_service.dart';
import 'package:jerupos/widgets/campo_texto.dart';
import 'package:jerupos/widgets/Ingrediente_producto_tile.dart';

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
  List<DropdownMenuEntry> _categorias = [];
  List<IngredienteProductoTile> _ingredientes = [];
  int _selectedCategoria = 0;

  Producto? producto;

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
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            CampoTexto(
              label: "Nombre",
              controller: _nombreController,
            ),
            CampoTexto(
              label: "Abreviacion",
              controller: _abreviacionController,
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
            FilledButton(
              style: FilledButton.styleFrom(
                elevation: 10,
                minimumSize: Size(0, 50),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                if (validateForm()) {
                  // crear producto
                }
              },
              child: Text("Crear Producto"),
            )
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
      errores += "La abreviacion no puede estar vacia.\n";
    }
    if (_precioController.text == "") {
      errores += "Debe indicar precio del producto.\n";
    }
    if (_selectedCategoria == 0) {
      errores += "Debe seleccionar una categoria.\n";
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
      ProductoService.get(widget.id!).then((producto) {
        setState(() {
          this.producto = producto;
        });
      });
    }
  }

  void _loadIngredientes() async {
    List<Ingrediente> ingredientes = await IngredienteService.list();
    List<IngredienteProductoTile> _tempIngredientes = [];
    for (var ingrediente in ingredientes) {
      _tempIngredientes.add(IngredienteProductoTile(ingrediente: ingrediente));
    }
    setState(() {
      _ingredientes = _tempIngredientes;
    });
  }
}
