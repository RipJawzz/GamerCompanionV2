import 'package:flutter/material.dart';
import 'package:frontend/Firebase/authentication.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/home_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Authentication"),
        elevation: 2.0,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () async {
                          user? authenticatedUser =
                              await Authentication().signInAnonymously();
                          if (authenticatedUser == null) {
                            print("Auth error");
                          } else if (authenticatedUser != null) {
                            print("signed in");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                        currUser: authenticatedUser,
                                      )),
                            );
                          }
                        },
                        child: const Text("Anonymous Signin"))
                  ],
                ),
              ),
              Flexible(child: Column()),
            ],
          ),
        ],
      ),
    );
  }
}
