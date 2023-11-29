import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jerupos/models/mensaje_chat.dart';
import 'package:jerupos/models/usuario.dart';
import 'package:jerupos/services/firebase_service.dart';
import 'package:jerupos/widgets/usuario_drawer.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _mensajeController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Usuario? _user;

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: UsuarioDrawer(),
        appBar: AppBar(
          title: Text('¡Chatea con otros asistentes! :-)'),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: Column(
          children: [
            Expanded(child: _chat()),
            _input(),
          ],
        ));
  }

  Widget _chat() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: StreamBuilder(
        stream: ChatService.obtenerMensajes(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).highlightColor),
            );
          }
          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              MensajeChat mensaje =
                  MensajeChat.fromSnapshot(snapshot.data!.docs[index]);
              return ListTile(
                title: Text(
                  mensaje.usuario,
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey[700]),
                ),
                subtitle: Text(
                  mensaje.mensaje,
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColorLight),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _input() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _mensajeController,
                decoration: InputDecoration(
                  hintText: 'Escribe tu mensaje',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, escribe un mensaje';
                  }
                  return null;
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ChatService.enviarMensaje(
                    MensajeChat(
                      mensaje: _mensajeController.text,
                      nombre: _user!.nombre,
                      apellido: _user!.apellido,
                      timestamp: DateTime.now(),
                    ),
                  );
                  _mensajeController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _getUser() {
    setState(() {
      _user = Provider.of<UsuarioProvider>(context, listen: false).usuario;
    });
  }
}
