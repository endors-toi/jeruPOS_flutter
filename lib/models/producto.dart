import 'package:jerupos/models/ingrediente_producto.dart';

class Producto {
  int? _id;
  String _nombre;
  String _abreviacion;
  int _precio;
  int _categoria;
  List<IngredienteProducto>? _ingredientes;

  // Constructor principal
  Producto({
    int? id,
    required String nombre,
    required String abreviacion,
    required int precio,
    required int categoria,
    List<IngredienteProducto>? ingredientes,
  })  : _id = id,
        _nombre = nombre,
        _abreviacion = abreviacion,
        _precio = precio,
        _categoria = categoria,
        _ingredientes = ingredientes;

  // Factories
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      abreviacion: json['abreviacion'],
      precio: json['precio'],
      categoria: json['categoria'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'nombre': _nombre,
      'abreviacion': _abreviacion,
      'precio': _precio,
      'categoria': _categoria,
      'ingredientes': _ingredientes?.map((item) => item.toJson()).toList(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': _nombre,
      'abreviacion': _abreviacion,
      'precio': _precio,
      'categoria': _categoria,
    };
  }

  // Getters
  int? get id => _id;
  String get nombre => _nombre;
  String get abreviacion => _abreviacion;
  int get precio => _precio;
  int get categoria => _categoria;
  List<IngredienteProducto>? get ingredientes => _ingredientes;

  // Setters
  set id(int? id) => _id = id;
  set nombre(String nombre) => _nombre = nombre;
  set abreviacion(String abreviacion) => _abreviacion = abreviacion;
  set precio(int precio) => _precio = precio;
  set categoriaId(int categoria) => _categoria = categoria;
  set ingredientes(List<IngredienteProducto>? ingredientes) =>
      _ingredientes = ingredientes;

  // Métodos
  Map<String, dynamic> post(Map<int, double> ingredientes) {
    Map<String, dynamic> prod = this.toMap();
    prod['ingredientes'] = ingredientes.keys.toList();
    prod['cantidades'] = ingredientes.values.toList();
    return prod;
  }
}
