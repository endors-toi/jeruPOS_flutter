import 'package:cloud_firestore/cloud_firestore.dart';

class MensajeChat {
  String? _id;
  String _mensaje;
  String _nombre;
  String _apellido;
  Timestamp _timestamp;

  MensajeChat({
    String? id,
    required String mensaje,
    required String nombre,
    required String apellido,
    required DateTime timestamp,
  })  : _id = id,
        _mensaje = mensaje,
        _nombre = nombre,
        _apellido = apellido,
        _timestamp = Timestamp.fromDate(timestamp);

  factory MensajeChat.fromSnapshot(QueryDocumentSnapshot doc) {
    return MensajeChat(
      id: doc.id,
      mensaje: doc['mensaje'],
      nombre: doc['nombre'],
      apellido: doc['apellido'],
      timestamp: doc['timestamp'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mensaje': _mensaje,
      'nombre': _nombre,
      'apellido': _apellido,
      'timestamp': _timestamp,
    };
  }

  //getters
  String? get id => _id;
  String get mensaje => _mensaje;
  String get nombre => _nombre;
  String get apellido => _apellido;
  String get usuario => "$_nombre $_apellido";
  DateTime get timestamp => _timestamp.toDate();

  //setters
  set id(String? id) => this._id = id;
  set mensaje(String mensaje) => this._mensaje = mensaje;
  set nombre(String nombre) => this._nombre = nombre;
  set apellido(String apellido) => this._apellido = apellido;
  set timestamp(DateTime timestamp) =>
      this._timestamp = Timestamp.fromDate(timestamp);
}
