import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:frontend/models/game.dart';
import 'package:frontend/models/otherUsers.dart';
import 'package:frontend/models/user.dart';

class Database {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  CollectionReference userData =
      FirebaseFirestore.instance.collection('UserData');
  CollectionReference gameData =
      FirebaseFirestore.instance.collection('GameData');

  void tryCreating() {
    for (int i = 1; i <= 21; ++i) {
      gameData
          .doc(i.toString())
          .set({"id": 0, "name": "", "description": "", "metacritic": 0});
    }
  }

  Future<void> updategameListFromSnapshot() async {
    for (int i = 1; i <= 21; ++i) {
      String url = await gameImageUrlGen(i);
      gameData.doc(i.toString()).update({"url": url});
    }
  }

  Future<user?> addNewUserFireStore(String uid, String email) async {
    try {
      await userData.doc(uid).set({
        "likedGames": [],
        "name": email.split("@")[0],
        "email": email,
        "following": []
      });
      user nwUser = user(uid: uid, anonymous: false);
      nwUser.email = email;
      return nwUser;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  void updateUserDoc(
    user currUser,
  ) async {
    userData.doc(currUser.uid.toString()).update({
      "likedGames": currUser.likedGames.toList(),
    });
  }

  void updateUserLikedGames(user currUser) async {
    userData
        .doc(currUser.uid.toString())
        .update({"likedGames": currUser.likedGames.toList()});
  }

  void updateUserFollowing(user currUser) async {
    userData
        .doc(currUser.uid.toString())
        .update({"following": currUser.following.toList()});
  }

  Future<List<OtherUser>?> otherUsersListFromFireStore(String uid,
      [Set<String>? tp]) async {
    try {
      List<OtherUser> req = [];
      await userData.get().then((QuerySnapshot querySnapshot) async {
        if (tp == null) {
          for (var doc in querySnapshot.docs) {
            if (doc.id != uid) {
              req.add(OtherUser(
                  uid: doc.id,
                  name: doc["name"],
                  email: doc["email"],
                  likedGames: doc["likedGames"].cast<int>().toSet()));
            }
          }
        } else {
          for (var doc in querySnapshot.docs) {
            if (doc.id != uid && tp.contains(doc.id)) {
              req.add(OtherUser(
                  uid: doc.id,
                  name: doc["name"],
                  email: doc["email"],
                  likedGames: doc["likedGames"].cast<int>().toSet()));
            }
          }
        }
      });
      return req;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<user> userFromFireStore(String uid, bool anonymous) async {
    DocumentSnapshot doc = await userData.doc(uid).get();
    user signedIn = user(uid: uid, anonymous: anonymous);
    if (!anonymous) {
      signedIn.likedGames = doc["likedGames"].cast<int>().toSet();
      signedIn.email = doc["email"];
      signedIn.name = doc["name"];
      signedIn.following = doc["following"].cast<String>().toSet();
    }
    return signedIn;
  }

  Future<List<Game>?> gameListFromSnapshot([Set<int>? tp]) async {
    try {
      List<Game> req = [];
      await gameData.get().then((QuerySnapshot querySnapshot) async {
        if (tp == null) {
          for (var doc in querySnapshot.docs) {
            req.add(
                Game(doc["id"], doc["name"], doc["description"], doc["url"]));
          }
        } else {
          for (var doc in querySnapshot.docs) {
            if (tp.contains(doc["id"] as int)) {
              req.add(
                  Game(doc["id"], doc["name"], doc["description"], doc["url"]));
            }
          }
        }
      });
      return req;
    } on Exception catch (e) {
      return null;
    }
  }

  Future<String> gameImageUrlGen(int id) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('images/${id.toString()}.png')
        .getDownloadURL();
    return downloadURL;
  }
}
