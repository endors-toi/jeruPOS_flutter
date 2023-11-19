import 'package:flutter/material.dart';
import 'package:jerupos/models/producto_pedido.dart';
import 'package:jerupos/services/pedido_service.dart';

class Pedido {
  int? _id;
  String? _estado;
  DateTime? _timestamp;
  String? _nombreCliente;
  int? _mesa;
  int? _idUsuario;
  List<ProductoPedido>? _productos;

  // Constructor principal
  Pedido({
    int? id,
    String? estado,
    DateTime? timestamp,
    String? nombreCliente,
    int? mesa,
    int? idUsuario,
    List<ProductoPedido>? productos,
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
        nombreCliente: json['nombre_cliente'] ?? null,
        mesa: json['mesa'] ?? null,
        idUsuario: json['usuario']);
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
          this._productos!.map((producto) => producto.toJson()).toList(),
    };
  }

  // Getters
  int? get id => this._id;
  String? get estado => this._estado;
  DateTime? get timestamp => this._timestamp;
  String? get nombreCliente => this._nombreCliente;
  int? get mesa => this._mesa;
  int? get idUsuario => this._idUsuario;
  List<ProductoPedido>? get productos => this._productos;

  // Setters
  set id(int? id) => this._id = id;
  set estado(String? estado) => this._estado = estado;
  set timestamp(DateTime? timestamp) => this._timestamp = timestamp;
  set nombreCliente(String? nombreCliente) =>
      this._nombreCliente = nombreCliente;
  set mesa(int? mesa) => this._mesa = mesa;
  set idUsuario(int? idUsuario) => this._idUsuario = idUsuario;
  set productos(List<ProductoPedido>? productos) => this._productos = productos;

  // Métodos
  void fetchProductos() async {
    this._productos = await PedidoService.getProductosPedido(this._id!);
  }

  Map<String, dynamic> post() {
    List<int> productosId =
        this.productos!.map((producto) => producto.id!).toList();
    List<int> cantidades =
        this.productos!.map((producto) => producto.cantidad).toList();
    String mesaOcliente = this.mesa != null ? 'mesa' : 'cliente';
    return {
      'usuario': this.idUsuario,
      mesaOcliente: this.mesa ?? this.nombreCliente,
      'productos': productosId,
      'cantidades': cantidades,
      'estado': 'PENDIENTE',
    };
  }
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
