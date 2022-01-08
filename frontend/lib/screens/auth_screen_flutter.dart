import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:frontend/Firebase/authentication.dart';
import 'package:frontend/Widgets/auth_autofill.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/home_screen.dart';

// ignore: must_be_immutable
class FlutterLoginScreen extends StatefulWidget {
  FlutterLoginScreen({Key? key, required this.email, required this.password})
      : super(key: key);
  String email, password;
  @override
  _FlutterLoginScreenState createState() => _FlutterLoginScreenState();
}

class _FlutterLoginScreenState extends State<FlutterLoginScreen> {
  @override
  Widget build(BuildContext context) {
    user currUser = user(uid: "0", anonymous: true);
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.white,
          content: Text("Nothing beyond this!",
              style: TextStyle(color: Colors.black)),
        ));
        return false;
      },
      child: FlutterLogin(
        savedEmail: widget.email,
        savedPassword: widget.password,
        theme: LoginTheme(
          primaryColor: Theme.of(context).primaryColor,
          accentColor: Theme.of(context).colorScheme.secondary,
          titleStyle:
              const TextStyle(fontSize: 40, color: Colors.white, inherit: true),
          cardTheme: const CardTheme(
            margin: EdgeInsets.all(8),
          ),
        ),
        logo: "assets/images/general/razer.png",
        navigateBackAfterRecovery: true,
        hideForgotPasswordButton: true,
        initialAuthMode: AuthMode.login,
        logoTag: "razer Logo",
        messages: LoginMessages(
          signUpSuccess: "Signed up Successfully!",
        ),
        onRecoverPassword: (string) {},
        title: "Gamer Companion",
        onLogin: (_loginData) async {
          currUser = (await Authentication().signInEmailPwd(
              _loginData.name.toString(), _loginData.password.toString()));
          if (currUser.name == null) {
            return currUser.email;
          }
          await saveAuthCred(_loginData.name, _loginData.password.toString());
        },
        onSignup: (_signupData) async {
          currUser = await Authentication().createAccEmailPwd(
              _signupData.name!,
              _signupData.password!,
              _signupData.additionalSignupData!["name"]!);
          if (currUser.name == null) {
            return currUser.email;
          }
          await saveAuthCred(_signupData.name!, _signupData.password!);
        },
        additionalSignupFields: [
          UserFormField(
            keyName: "name",
            displayName: "name",
            fieldValidator: (val) =>
                val!.isEmpty ? 'Enter a non-empty name' : null,
          ),
        ],
        onSubmitAnimationCompleted: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      currUser: currUser,
                    )),
          );
        },
      ),
    );
  }
}
