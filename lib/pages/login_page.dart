import 'package:flutter/material.dart';
import 'package:jerupos/widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget body = LoginForm();

  // pendiente: Revisar si existe refresh token antes de mostrar el LoginForm

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
    );
  }
}
