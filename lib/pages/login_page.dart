import 'package:flutter/material.dart';
import 'package:jerupos/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _userCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              flex: 1,
              child:
                  Container(child: Image.asset('assets/images/logo-min.png'))),
          Expanded(
              flex: 2,
              child: ListView(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _userCtrl,
                    decoration: InputDecoration(
                      labelText: 'Nombre de Usuario',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _passCtrl,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: Text('Login'),
                  ),
                ),
              ])),
        ]),
      ),
    );
  }
}
