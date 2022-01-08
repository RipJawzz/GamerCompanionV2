import 'package:flutter/material.dart';
import 'package:frontend/Widgets/misc_widgets.dart';
import 'package:frontend/screens/auth_screen_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthAutofill extends StatefulWidget {
  const AuthAutofill({Key? key}) : super(key: key);

  @override
  _AuthAutofillState createState() => _AuthAutofillState();
}

class _AuthAutofillState extends State<AuthAutofill> {
  bool loading = true;
  String email = "", password = "";
  @override
  Widget build(BuildContext context) {
    getAuthState();
    return loading
        ? const LoadingWidget()
        : FlutterLoginScreen(
            email: email,
            password: password,
          );
  }

  void getAuthState() async {
    if (loading) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? saved = prefs.getBool('saved');
      loading = false;
      if (saved == null) {
        prefs.setBool('saved', false);
        prefs.setString('email', '');
        prefs.setString('password', '');
      } else if (saved) {
        email = (prefs.getString('email'))!;
        password = (prefs.getString('password'))!;
      }
      setState(() {});
    }
  }
}

Future<void> saveAuthCred(String email, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('saved', true);
  await prefs.setString('email', email);
  await prefs.setString('password', password);
}
