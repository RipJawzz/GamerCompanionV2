import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
      print(e);
      return null;
    }
  }

  Future<user?> createAccEmailPwd([String? email, String? password]) async {
    email ??= "bignubz@gmail.com";
    password ??= "MyHyperSEcretpwd";
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return Database().addNewUserFireStore(userCredential.user!.uid, email);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<user?> signInEmailPwd([String? email, String? password]) async {
    email ??= "bignubz@gmail.com";
    password ??= "MyHyperSEcretpwd";
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return await Database()
          .userFromFireStore(userCredential.user!.uid, false);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> signOut() async {
    try {
      await _auth.signOut();
      return "Success";
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
