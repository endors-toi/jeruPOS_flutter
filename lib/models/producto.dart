import 'package:jerupos/models/ingrediente.dart';

class Producto {
  int? _id;
  String _nombre;
  String _abreviacion;
  int _precio;
  int _categoria;
  List<Ingrediente>? _ingredientes;

  // Constructor principal
  Producto({
    int? id,
    required String nombre,
    required String abreviacion,
    required int precio,
    required int categoria,
    List<Ingrediente>? ingredientes,
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
      'categoriaId': _categoria,
      'ingredientes': _ingredientes?.map((item) => item.toJson()).toList(),
    };
  }

  // Getters
  int? get id => _id;
  String get nombre => _nombre;
  String get abreviacion => _abreviacion;
  int get precio => _precio;
  int get categoria => _categoria;
  List<Ingrediente>? get ingredientes => _ingredientes;

  // Setters
  set id(int? id) => _id = id;
  set nombre(String nombre) => _nombre = nombre;
  set abreviacion(String abreviacion) => _abreviacion = abreviacion;
  set precio(int precio) => _precio = precio;
  set categoriaId(int categoria) => _categoria = categoria;
  set ingredientes(List<Ingrediente>? ingredientes) =>
      _ingredientes = ingredientes;
}
