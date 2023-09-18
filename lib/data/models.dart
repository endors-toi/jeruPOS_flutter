class Rol {
  final int id;
  final String nombreRol;

  Rol({
    required this.id,
    required this.nombreRol,
  });
}

class Usuario {
  final int id;
  final Rol rol;
  final String nombre;
  final String apellido;
  final String nombreUsuario;
  final String contrasena;

  Usuario({
    required this.id,
    required this.rol,
    required this.nombre,
    required this.apellido,
    required this.nombreUsuario,
    required this.contrasena,
  });
}

class Ingrediente {
  final int id;
  final String nombre;
  final int cantidadDisponible;
  final int cantidadCritica;

  Ingrediente({
    required this.id,
    required this.nombre,
    required this.cantidadDisponible,
    required this.cantidadCritica,
  });
}

class Categoria {
  final int id;
  final String nombre;

  Categoria({
    required this.id,
    required this.nombre,
  });
}

class Producto {
  final int id;
  final String nombre;
  final String abreviatura;
  final int idCategoria;
  final double precio;

  Producto({
    required this.id,
    required this.nombre,
    required this.abreviatura,
    required this.idCategoria,
    required this.precio,
  });
}

class PedidoProducto {
  final Producto producto;
  final List<Ingrediente> ingredientes;

  PedidoProducto({
    required this.producto,
    required this.ingredientes,
  });
}

class Orden {
  static int _lastId = 0;
  final int id;
  final Usuario usuario;
  final DateTime timestamp;
  final String estado;
  int? numeroMesa;
  String? nombreCliente;

  Orden({
    required this.usuario,
    required this.timestamp,
    this.estado = "Preparando",
    this.numeroMesa,
    this.nombreCliente,
  }) : id = _lastId++;
}

class ProductoOrden {
  final int idOrden;
  final List<Producto> productos;
  final int cantidad;

  ProductoOrden({
    required this.idOrden,
    required this.productos,
    required this.cantidad,
  });
}
