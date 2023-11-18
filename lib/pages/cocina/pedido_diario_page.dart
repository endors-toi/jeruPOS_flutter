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

    return GridView.builder(
      gridDelegate: MediaQuery.of(context).orientation == Orientation.landscape
          ? SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              childAspectRatio: 6,
            )
          : SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 8,
              childAspectRatio: 6,
            ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        ItemPedido item = _items[index];
        return CheckboxListTile(
          enableFeedback: true,
          selectedTileColor: Colors.orange,
          controlAffinity: ListTileControlAffinity.leading,
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
