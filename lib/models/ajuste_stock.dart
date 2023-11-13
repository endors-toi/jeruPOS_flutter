class AjusteStock {
  int? _id;
  int _ingrediente;
  DateTime? _fecha;
  String _tipoAjuste;
  int _cantidad;
  String _motivo;
  int _usuario;

  // Constructor principal
  AjusteStock(
      {int? id,
      required int ingrediente,
      DateTime? fecha,
      required String tipoAjuste,
      required int cantidad,
      required String motivo,
      required int usuario})
      : _id = id,
        _ingrediente = ingrediente,
        _fecha = fecha,
        _tipoAjuste = tipoAjuste,
        _cantidad = cantidad,
        _motivo = motivo,
        _usuario = usuario;

  // Factory
  factory AjusteStock.fromJson(Map<String, dynamic> json) {
    return AjusteStock(
      id: json['id'],
      ingrediente: json['ingrediente'],
      fecha: DateTime.parse(json['fecha']),
      tipoAjuste: json['tipo_ajuste'],
      cantidad: json['cantidad'],
      motivo: json['motivo'],
      usuario: json['usuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this._id,
      'ingrediente': this._ingrediente,
      'fecha': this._fecha.toString(),
      'tipo_ajuste': this._tipoAjuste,
      'cantidad': this._cantidad,
      'motivo': this._motivo,
      'usuario': this._usuario,
    };
  }

  // Getters
  int? get id => this._id;
  int get ingrediente => this._ingrediente;
  DateTime? get fecha => this._fecha;
  String get tipoAjuste => this._tipoAjuste;
  int get cantidad => this._cantidad;
  String get motivo => this._motivo;
  int get usuario => this._usuario;

  // Setters
  set id(int? id) => this._id = id;
  set ingrediente(int ingrediente) => this._ingrediente = ingrediente;
  set fecha(DateTime? fecha) => this._fecha = fecha;
  set tipoAjuste(String tipoAjuste) => this._tipoAjuste = tipoAjuste;
  set cantidad(int cantidad) => this._cantidad = cantidad;
  set motivo(String motivo) => this._motivo = motivo;
  set usuario(int usuario) => this._usuario = usuario;
}
