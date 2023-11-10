import 'package:flutter/material.dart';
import 'package:jerupos/models/ingrediente.dart';
import 'package:jerupos/services/ingrediente_service.dart';
import 'package:jerupos/utils/mostrar_snackbar.dart';

class IngresoDiario extends StatefulWidget {
  const IngresoDiario({super.key});

  @override
  State<IngresoDiario> createState() => _IngresoDiarioState();
}

class _IngresoDiarioState extends State<IngresoDiario> {
  Map<int, TextEditingController> _controllers = {};
  Map<int, int> _cantidades = {};

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: FutureBuilder(
          future: IngredienteService.list(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              var ingredientes = snapshot.data;
              ingredientes.forEach((ingrediente) {
                _controllers.putIfAbsent(
                    ingrediente.id, () => TextEditingController());
                _cantidades.putIfAbsent(
                    ingrediente.id, () => ingrediente.cantidadDisponible);
              });
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        height: 8,
                        color: Colors.transparent,
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        Ingrediente ingrediente = ingredientes[index];
                        return TextFormField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.add),
                              label: Text("${ingrediente.nombre}",
                                  style: TextStyle(fontSize: 20)),
                              border: OutlineInputBorder()),
                          controller: _controllers[ingrediente.id],
                          keyboardType: TextInputType.number,
                          validator: (cantidad) {
                            if (cantidad != "" &&
                                int.tryParse(cantidad!) == null) {
                              return "Ingrese un número";
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(8),
                          minimumSize: MaterialStateProperty.all(Size(0, 50))),
                      onPressed: () {
                        _enviarIngreso().then((_) {
                          mostrarSnackBar(
                              context, "Ingreso realizado correctamente.");
                          setState(() {
                            _controllers = {};
                            _cantidades = {};
                          });
                        });
                      },
                      child: Text(
                        "REALIZAR INGRESO",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _enviarIngreso() async {
    for (int id in _controllers.keys) {
      var controller = _controllers[id];
      if (controller != null) {
        int cantidadIngresada = int.tryParse(controller.text) ?? 0;
        int cantidadActual = _cantidades[id] ?? 0;
        int cantidadNueva = cantidadActual + cantidadIngresada;
        await IngredienteService.patch(
            {'cantidad_disponible': cantidadNueva}, id);
      }
    }
  }
}
