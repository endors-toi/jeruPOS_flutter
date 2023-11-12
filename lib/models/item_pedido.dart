class ItemPedido {
  int id;
  String nombre;
  bool selected;

  ItemPedido({required this.id, required this.nombre, this.selected = false});

  factory ItemPedido.fromJson(Map<String, dynamic> json) {
    return ItemPedido(
      id: json['id'],
      nombre: json['nombre'],
      selected: json['selected'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'selected': selected,
      };
}
