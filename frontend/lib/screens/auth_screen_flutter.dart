import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:frontend/Firebase/authentication.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/home_screen.dart';

class FlutterLoginScreen extends StatefulWidget {
  const FlutterLoginScreen({Key? key}) : super(key: key);

  @override
  _FlutterLoginScreenState createState() => _FlutterLoginScreenState();
}

class _FlutterLoginScreenState extends State<FlutterLoginScreen> {
  @override
  Widget build(BuildContext context) {
    user? currUser;
    return FlutterLogin(
      title: "Gamer Companion",
      onLogin: (LoginData) async {
        currUser = (await Authentication().signInEmailPwd(
            LoginData.name.toString(), LoginData.password.toString()))!;
      },
      onSignup: (LoginData) async {
        currUser = (await Authentication().createAccEmailPwd(
            LoginData.name.toString(), LoginData.password.toString()))!;
      },
      onRecoverPassword: (String) {},
      onSubmitAnimationCompleted: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    currUser: currUser!,
                  )),
        );
      },
    );
  }
}
