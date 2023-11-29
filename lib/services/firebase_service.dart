import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseService {
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
