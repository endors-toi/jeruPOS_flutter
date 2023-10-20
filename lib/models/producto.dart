class Producto {
  int _id;
  String _nombre;
  int _cantidad;
  int _precio;

  // Constructor principal
  Producto(this._id, this._nombre, this._cantidad, this._precio);

  // Factories
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      json['id'],
      json['nombre'],
      json['cantidad'],
      json['precio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this._id,
      'nombre': this._nombre,
      'cantidad': this._cantidad,
      'precio': this._precio,
    };
  }

  // Getters
  int get id => this._id;
  String get nombre => this._nombre;
  int get cantidad => this._cantidad;
  int get precio => this._precio;

  // Setters
  set id(int id) => this._id = id;
  set nombre(String nombre) => this._nombre = nombre;
  set cantidad(int cantidad) => this._cantidad = cantidad;
  set precio(int precio) => this._precio = precio;
}
