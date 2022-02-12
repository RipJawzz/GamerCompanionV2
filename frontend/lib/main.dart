import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/API/django_api.dart';
import 'package:frontend/Widgets/auth_autofill.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //setGameData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Gamer Companion',
      theme: ThemeData(
          errorColor: Colors.red[600],
          scaffoldBackgroundColor: Colors.black,
          canvasColor: Colors.grey[850],
          primaryColor: Colors.black,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
              .copyWith(secondary: Colors.green)),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthAutofill(),
      },
    );
  }
}
