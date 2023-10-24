class Producto {
  int? _id;
  String? _nombre;
  int _cantidad;
  int? _precio;
  String? _abreviacion;

  // Constructor principal
  Producto({
    int? id,
    String? nombre,
    int cantidad = 1,
    int? precio,
    String? abreviacion,
  })  : _id = id,
        _nombre = nombre,
        _cantidad = cantidad,
        _precio = precio,
        _abreviacion = abreviacion;

  // Factories
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      cantidad: json['cantidad'] ?? 1,
      precio: json['precio'],
      abreviacion: json['abreviacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this._id,
      'nombre': this._nombre,
      'cantidad': this._cantidad,
      'precio': this._precio,
      'abreviacion': this._abreviacion,
    };
  }

  // Getters
  int? get id => this._id;
  String? get nombre => this._nombre;
  int get cantidad => this._cantidad;
  int? get precio => this._precio;
  String? get abreviacion => this._abreviacion;

  // Setters
  set id(int? id) => this._id = id;
  set nombre(String? nombre) => this._nombre = nombre;
  set cantidad(int cantidad) => this._cantidad = cantidad;
  set precio(int? precio) => this._precio = precio;
  set abreviacion(String? abreviacion) => this._abreviacion = abreviacion;

  // Métodos
  void incrementarCantidad() {
    _cantidad++;
  }

  void decrementarCantidad() {
    if (_cantidad > 1) {
      _cantidad--;
    }
  }
}
