import 'package:flutter/material.dart';
import 'package:jerupos/pages/cocina/reporte_diario.dart';
import 'package:jerupos/services/ingrediente_service.dart';
import 'package:provider/provider.dart';

class InventarioPage extends StatefulWidget {
  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage>
    with AutomaticKeepAliveClientMixin<InventarioPage> {
  Map<int, TextEditingController> _controllers = {};
  Map<int, int> _cantidadesActuales = {};
  Map<int, int> _cantidadesReportadas = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(children: [
        Container(
          child: FutureBuilder(
            future: IngredienteService.list(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                var ingredientes = snapshot.data;
                _initializeMaps(ingredientes);
                return Expanded(
                  child: GridView.builder(
                    gridDelegate: MediaQuery.of(context).orientation ==
                            Orientation.landscape
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
                    itemCount: ingredientes.length,
                    itemBuilder: (context, index) {
                      var ingrediente = ingredientes[index];
                      return TextFormField(
                        controller: _controllers[ingrediente.id],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: ingrediente.nombre,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _cantidadesReportadas[ingrediente.id] =
                              int.parse(value);
                          Provider.of<ReporteDiarioData>(context, listen: false)
                              .updateInventario(
                                  _cantidadesReportadas, _cantidadesActuales);
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ]),
    );
  }

  void _initializeMaps(ingredientes) {
    ingredientes.forEach((ingrediente) {
      _controllers.putIfAbsent(ingrediente.id, () => TextEditingController());
      _cantidadesActuales.putIfAbsent(
          ingrediente.id, () => ingrediente.cantidadDisponible);
    });
  }
}
