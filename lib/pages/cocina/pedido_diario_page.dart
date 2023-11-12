import 'package:flutter/material.dart';
import 'package:jerupos/models/item_pedido.dart';
import 'package:jerupos/pages/cocina/reporte_diario.dart';
import 'package:jerupos/services/pedido_diario_service.dart';
import 'package:provider/provider.dart';

class PedidoDiarioPage extends StatefulWidget {
  @override
  State<PedidoDiarioPage> createState() => _PedidoDiarioPageState();
}

class _PedidoDiarioPageState extends State<PedidoDiarioPage>
    with AutomaticKeepAliveClientMixin<PedidoDiarioPage> {
  List<int> _itemsSeleccionados = [];
  List<ItemPedido> _items = [];
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    var items = await PedidoDiarioService.list();
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        ItemPedido item = _items[index];
        return CheckboxListTile(
          title: Text(item.nombre),
          value: _itemsSeleccionados.contains(item.id),
          onChanged: (value) {
            if (value ?? false) {
              _itemsSeleccionados.add(item.id);
            } else {
              _itemsSeleccionados.remove(item.id);
            }
            Provider.of<ReporteDiarioData>(context, listen: false)
                .updatePedidoDiario(_itemsSeleccionados);
            setState(() {});
          },
        );
      },
    );
  }
}
