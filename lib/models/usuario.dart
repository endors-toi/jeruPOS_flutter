class Usuario {
  int? id;
  int idRol;
  String nombre;
  String apellido;
  String? nombreUsuario;
  String contrasena;

  Usuario({
    this.id,
    required this.idRol,
    required this.nombre,
    required this.apellido,
    this.nombreUsuario,
    required this.contrasena,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      idRol: json['id_rol'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      nombreUsuario: json['nombre_usuario'],
      contrasena: json['contrasena'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_rol': idRol,
      'nombre': nombre,
      'apellido': apellido,
      'nombre_usuario': nombreUsuario,
      'contrasena': contrasena,
    };
  }
}
