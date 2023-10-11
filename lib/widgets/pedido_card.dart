import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PedidoCard extends StatelessWidget {
  final Map<String, dynamic> pedido;
  final GestureTapUpCallback? onTap;
  final Widget? buttonLabel;

  PedidoCard({
    required this.pedido,
    this.onTap,
    this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> productos = pedido['productos'] ?? [];
    final String fTimestamp =
        DateFormat('hh:mm').format(DateTime.parse(pedido['timestamp']));
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.5),
              blurRadius: 2,
              offset: Offset(6, 6),
            )
          ],
          borderRadius: BorderRadius.circular(18),
        ),
        child: Card(
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: GestureDetector(
              onTapUp: onTap,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 246, 227),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('#${pedido['id']}'),
                        Spacer(),
                        Text(pedido['mesa'] != null
                            ? "Mesa ${pedido['mesa']}"
                            : "Para Llevar"),
                      ],
                    ),
                    Row(
                      children: [
                        Text('${pedido['estado']}'),
                        Spacer(),
                        Text('$fTimestamp'),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: productos.length,
                        itemBuilder: (context, index) {
                          var producto = productos[index];
                          return Text(
                              "${producto['cantidad']} x ${producto['nombre']}");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
