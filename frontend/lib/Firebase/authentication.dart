import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/API/django_api.dart';
import 'package:frontend/Firebase/database.dart';
import 'dart:async';

import 'package:frontend/models/user.dart';

class Authentication {
  Authentication();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<user?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return user(uid: userCredential.user!.uid, anonymous: true);
    } catch (e) {
      return null;
    }
  }

  Future<user> createAccEmailPwd(
      String email, String password, String name) async {
    user curr;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      createUser(userCredential.user!.uid);

      curr = await Database()
          .addNewUserFireStore(userCredential.user!.uid, email, name);
      return curr;
    } catch (e) {
      curr = user(uid: "0", anonymous: false);
      curr.name = null;
      curr.email = e.toString();
      return curr;
    }
  }

  Future<user> signInEmailPwd(String email, String password) async {
    user curr;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      curr =
          await Database().userFromFireStore(userCredential.user!.uid, false);
      return curr;
    } catch (e) {
      curr = user(uid: "0", anonymous: false);
      curr.name = null;
      curr.email = e.toString();
      return curr;
    }
  }

  Future<String?> signOut() async {
    try {
      await _auth.signOut();
      return "Success";
    } catch (e) {
      return null;
    }
  }
}
