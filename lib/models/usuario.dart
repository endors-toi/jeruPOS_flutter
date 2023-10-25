class Usuario {
  int? _id;
  String _nombre;
  String _apellido;
  String _email;
  int _rol;
  String? _password;
  String? _password2;

  // Constructor principal
  Usuario({
    int? id,
    required String nombre,
    required String apellido,
    required String email,
    required int rol,
    String? password,
    String? password2,
  })  : _id = id,
        _nombre = nombre,
        _apellido = apellido,
        _email = email,
        _rol = rol,
        _password = password,
        _password2 = password2;

  // Factories
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      email: json['email'],
      rol: json['rol'],
      password: json['password'],
      password2: json['password2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this._id,
      'nombre': this._nombre,
      'apellido': this._apellido,
      'email': this._email,
      'rol': this._rol,
      'password': this._password,
      'password2': this._password2,
    };
  }

  // Getters
  int? get id => this._id;
  String get nombre => this._nombre;
  String get apellido => this._apellido;
  String get email => this._email;
  int get rol => this._rol;
  String? get password => this._password;
  String? get password2 => this._password2;

  // Setters
  set id(int? id) => this._id = id;
  set nombre(String nombre) => this._nombre = nombre;
  set apellido(String apellido) => this._apellido = apellido;
  set email(String email) => this._email = email;
  set rol(int rol) => this._rol = rol;
  set password(String? password) => this._password = password;
  set password2(String? password2) => this._password2 = password2;

  // Métodos
}
