import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jerupos/models/mensaje_chat.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String> getToken() async {
    String token = await _firebaseMessaging.getToken() ?? '';
    print('Token: $token');
    return token;
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    getToken();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}

class ChatService {
  static final CollectionReference chat =
      FirebaseFirestore.instance.collection('chat');

  // obtener mensajes
  static Stream<QuerySnapshot> obtenerMensajes() {
    return chat.orderBy('timestamp', descending: true).snapshots();
  }

  // agregar mensaje al chat
  static Future<void> enviarMensaje(MensajeChat mensaje) {
    return chat.add(mensaje.toMap());
  }

  // editar mensaje
  static Future<void> editarMensaje(String id, MensajeChat mensaje) {
    return chat.doc(id).collection('mensajes').doc(id).update(mensaje.toMap());
  }

  // eliminar mensaje
  static Future<void> eliminarMensaje(String id) {
    return chat.doc(id).collection('mensajes').doc(id).delete();
  }
}
