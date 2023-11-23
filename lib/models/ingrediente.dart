class Ingrediente {
  int? _id;
  String _nombre;
  double _cantidadDisponible;
  double _cantidadCritica;
  String _unidad;

  // Constructor principal
  Ingrediente(
      {int? id,
      required String nombre,
      required double cantidadDisponible,
      required double cantidadCritica,
      required String unidad})
      : this._id = id,
        this._nombre = nombre,
        this._cantidadDisponible = cantidadDisponible,
        this._cantidadCritica = cantidadCritica,
        this._unidad = unidad;

  // Factories
  factory Ingrediente.fromJson(Map<String, dynamic> json) {
    return Ingrediente(
      id: json['id'],
      nombre: json['nombre'],
      cantidadDisponible: json['cantidad_disponible'],
      cantidadCritica: json['cantidad_critica'],
      unidad: json['unidad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this._id,
      'nombre': this._nombre,
      'cantidad_disponible': this._cantidadDisponible,
      'cantidad_critica': this._cantidadCritica,
      'unidad': this._unidad,
    };
  }

  // Getters
  int? get id => this._id;
  String get nombre => this._nombre;
  double get cantidadDisponible => this._cantidadDisponible;
  double get cantidadCritica => this._cantidadCritica;
  String get unidad => this._unidad;

  // Setters
  set id(int? id) => this._id = id;
  set nombre(String nombre) => this._nombre = nombre;
  set cantidadDisponible(double cantidadDisponible) =>
      this._cantidadDisponible = cantidadDisponible;
  set cantidadCritica(double cantidadCritica) =>
      this._cantidadCritica = cantidadCritica;
  set unidad(String unidad) => this._unidad = unidad;
}
