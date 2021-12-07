import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
}
