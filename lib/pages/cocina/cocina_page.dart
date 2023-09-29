import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CocinaPage extends StatefulWidget {
  @override
  State<CocinaPage> createState() => _CocinaPageState();
}

class _CocinaPageState extends State<CocinaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('JeruPOS'),
      ),
      body: Center(child: Text("Cocina")),
    );
  }
}
