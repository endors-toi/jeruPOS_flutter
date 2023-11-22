import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jerupos/models/usuario.dart';
import 'package:jerupos/pages/login_page.dart';
import 'package:jerupos/services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bot_toast/bot_toast.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseService().initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UsuarioProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(builder: BotToastInit()),
        navigatorObservers: [BotToastNavigatorObserver()],
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 145, 0)),
          useMaterial3: true,
        ),
        home: LoginPage(),
      ),
    );
  }
}
