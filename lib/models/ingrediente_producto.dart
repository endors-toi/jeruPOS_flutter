class IngredienteProducto {
  int producto;
  int ingrediente;
  String nombreIngrediente;
  String unidad;
  double cantidad;

  IngredienteProducto({
    required this.producto,
    required this.ingrediente,
    required this.nombreIngrediente,
    required this.unidad,
    required this.cantidad,
  });

  factory IngredienteProducto.fromJson(Map<String, dynamic> json) {
    return IngredienteProducto(
      producto: json['producto'],
      ingrediente: json['ingrediente'],
      nombreIngrediente: json['nombreIngrediente'],
      unidad: json['unidad'],
      cantidad: json['cantidad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'producto': this.producto,
      'ingrediente': this.ingrediente,
      'cantidad': this.cantidad,
    };
  }
}
