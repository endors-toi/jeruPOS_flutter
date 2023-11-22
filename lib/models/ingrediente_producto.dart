class IngredienteProducto {
  int producto;
  int ingrediente;
  int cantidad;

  IngredienteProducto({
    required this.producto,
    required this.ingrediente,
    required this.cantidad,
  });

  factory IngredienteProducto.fromJson(Map<String, dynamic> json) {
    return IngredienteProducto(
      producto: json['producto'],
      ingrediente: json['ingrediente'],
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
