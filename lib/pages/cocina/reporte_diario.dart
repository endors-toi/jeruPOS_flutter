import 'package:flutter/material.dart';
import 'package:jerupos/models/ajuste_stock.dart';
import 'package:jerupos/models/usuario.dart';
import 'package:jerupos/pages/cocina/inventario_page.dart';
import 'package:jerupos/pages/cocina/pedido_diario_page.dart';
import 'package:jerupos/services/ingrediente_service.dart';
import 'package:jerupos/services/pedido_diario_service.dart';
import 'package:jerupos/services/stock_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ReporteDiarioData extends ChangeNotifier {
  List<int> pedidoDiario;
  Map<int, int> inventario;
  Map<int, int> stockActual;

  ReporteDiarioData(
      {this.pedidoDiario = const [],
      this.inventario = const {},
      this.stockActual = const {}});

  void updatePedidoDiario(List<int> pedidoDiario) {
    this.pedidoDiario = pedidoDiario;
    notifyListeners();
  }

  void updateInventario(Map<int, int> inventario, Map<int, int> stockActual) {
    this.inventario = inventario;
    this.stockActual = stockActual;
    notifyListeners();
  }
}

class ReporteDiario extends StatefulWidget {
  @override
  State<ReporteDiario> createState() => _ReporteDiarioState();
}

class _ReporteDiarioState extends State<ReporteDiario> {
  Usuario? usuario;

  @override
  void initState() {
    super.initState();
    this.usuario = Provider.of<UsuarioProvider>(context, listen: false).usuario;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReporteDiarioData(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          leading: Icon(MdiIcons.receiptText),
          title: Text("REPORTE DIARIO", style: TextStyle(fontSize: 24)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: PageView(
          children: [
            InventarioPage(),
            PedidoDiarioPage(),
          ],
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(16),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0))),
                minimumSize: MaterialStateProperty.all(Size(0, 50)),
              ),
              onPressed: () {
                final reporteDiario =
                    Provider.of<ReporteDiarioData>(context, listen: false);
                _enviarPedidoDiario(reporteDiario.pedidoDiario);
                _enviarInventario(
                    reporteDiario.inventario, reporteDiario.stockActual);
              },
              child: Text(
                "ENVIAR",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }

  void _enviarPedidoDiario(List<int> pedidoDiario) async {
    for (int id in pedidoDiario) {
      await PedidoDiarioService.patch({'selected': true}, id);
    }
  }

  void _enviarInventario(
      Map<int, int> inventario, Map<int, int> stockActual) async {
    for (int id in inventario.keys) {
      int cantReportada = inventario[id] ?? 0;
      int cantActual = stockActual[id] ?? 0;
      int diferencia = cantReportada - cantActual;
      if (diferencia != 0) {
        AjusteStock ajuste = AjusteStock(
          ingrediente: id,
          tipoAjuste: diferencia > 0 ? "SUMA" : "RESTA",
          cantidad: diferencia.abs(),
          motivo: "Reporte diario",
          usuario: usuario!.id!,
        );
        await StockService.create(ajuste);
        await IngredienteService.patch(
            {'cantidad_disponible': cantReportada}, id);
      }
    }
  }
}
