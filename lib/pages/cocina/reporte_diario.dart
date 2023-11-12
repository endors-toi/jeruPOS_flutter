import 'package:flutter/material.dart';
import 'package:jerupos/pages/cocina/inventario_page.dart';
import 'package:jerupos/pages/cocina/pedido_diario_page.dart';
import 'package:jerupos/services/pedido_diario_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ReporteDiarioData extends ChangeNotifier {
  List<int> pedidoDiario;
  Map<int, int> stockReportado;

  ReporteDiarioData(
      {this.pedidoDiario = const [], this.stockReportado = const {}});

  void updatePedidoDiario(List<int> pedidoDiario) {
    this.pedidoDiario = pedidoDiario;
    notifyListeners();
  }

  void updateStockReportado(Map<int, int> stockReportado) {
    this.stockReportado = stockReportado;
    notifyListeners();
  }
}

class ReporteDiario extends StatefulWidget {
  const ReporteDiario({super.key});

  @override
  State<ReporteDiario> createState() => _ReporteDiarioState();
}

class _ReporteDiarioState extends State<ReporteDiario> {
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
                _enviarPedidoDiario(reporteDiario);
              },
              child: Text(
                "ENVIAR",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }

  void _enviarPedidoDiario(ReporteDiarioData reporteDiario) async {
    for (int id in reporteDiario.pedidoDiario) {
      await PedidoDiarioService.patch({'selected': true}, id);
    }
  }
}
