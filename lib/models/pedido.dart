import 'package:flutter/material.dart';
import 'package:jerupos/models/producto.dart';

class Pedido {
  int? _id;
  String? _estado;
  DateTime? _timestamp;
  String? _nombreCliente;
  int? _mesa;
  int? _idUsuario;
  List<Producto> _productos;

  // Constructor principal
  Pedido({
    int? id,
    String? estado,
    DateTime? timestamp,
    String? nombreCliente,
    int? mesa,
    int? idUsuario,
    required List<Producto> productos,
  })  : _id = id,
        _estado = estado,
        _timestamp = timestamp,
        _nombreCliente = nombreCliente,
        _mesa = mesa,
        _idUsuario = idUsuario,
        _productos = productos;

  // Factories
  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      estado: json['estado'],
      timestamp: DateTime.parse(json['timestamp']),
      nombreCliente: json['nombre_cliente'],
      mesa: json['mesa'],
      idUsuario: json['id_usuario'],
      productos: json['productos']
          .map<Producto>((producto) => Producto.fromJson(producto))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this._id,
      'estado': this._estado,
      'timestamp': this._timestamp.toString(),
      'nombre_cliente': this._nombreCliente,
      'mesa': this._mesa,
      'id_usuario': this._idUsuario,
      'productos':
          this._productos.map((producto) => producto.toJson()).toList(),
    };
  }

  // Getters
  int? get id => this._id;
  String? get estado => this._estado;
  DateTime? get timestamp => this._timestamp;
  String? get nombreCliente => this._nombreCliente;
  int? get mesa => this._mesa;
  int? get idUsuario => this._idUsuario;
  List<Producto> get productos => this._productos;

  // Setters
  set id(int? id) => this._id = id;
  set estado(String? estado) => this._estado = estado;
  set timestamp(DateTime? timestamp) => this._timestamp = timestamp;
  set nombreCliente(String? nombreCliente) =>
      this._nombreCliente = nombreCliente;
  set mesa(int? mesa) => this._mesa = mesa;
  set idUsuario(int? idUsuario) => this._idUsuario = idUsuario;
  set productos(List<Producto> productos) => this._productos = productos;
}

class PedidoProvider with ChangeNotifier {
  List<Pedido> _pedidos = [];

  List<Pedido> get pedidos => this._pedidos;

  void addPedido(Pedido nuevoPedido) {
    this._pedidos.insert(0, nuevoPedido);
    notifyListeners();
  }

  void updatePedido(Pedido pedido) {
    int index = this._pedidos.indexWhere((p) => p.id == pedido.id);
    this._pedidos[index] = pedido;
    notifyListeners();
  }

  void deletePedido(int id) {
    this._pedidos.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
