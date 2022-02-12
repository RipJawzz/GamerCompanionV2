import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:frontend/models/game.dart';
import 'package:frontend/models/other_users.dart';
import 'package:frontend/models/user.dart';

class Database {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  CollectionReference userData =
      FirebaseFirestore.instance.collection('UserData');
  CollectionReference gameData =
      FirebaseFirestore.instance.collection('GameData');

  Future<void> updategameListFromSnapshot() async {
    for (int i = 1; i <= 21; ++i) {
      String url = await gameImageUrlGen(i);
      gameData.doc(i.toString()).update({"url": url});
    }
  }

  Future<user> addNewUserFireStore(
      String uid, String email, String name) async {
    user nwUser = user(uid: uid, anonymous: false);
    try {
      await userData.doc(uid).set({
        "likedGames": [],
        "name": name,
        "email": email,
        "following": [],
        "factor": 40,
      });
      nwUser.name = name;
      nwUser.email = email;
      return nwUser;
    } catch (e) {
      nwUser.name = null;
      nwUser.email = e.toString();
      return nwUser;
    }
  }

  Future<user> userFromFireStore(String uid, bool anonymous) async {
    user signedIn = user(uid: uid, anonymous: anonymous);
    try {
      DocumentSnapshot doc = await userData.doc(uid).get();

      if (!anonymous) {
        signedIn.likedGames = doc["likedGames"].cast<int>().toSet();
        signedIn.email = doc["email"];
        signedIn.name = doc["name"];
        signedIn.factor = doc["factor"] as int;
        signedIn.following = doc["following"].cast<String>().toSet();
      }
      return signedIn;
    } catch (e) {
      signedIn.name = null;
      signedIn.email = e.toString();
      return signedIn;
    }
  }

  Future<bool> updateUserFactor(user currUser) async {
    try {
      await userData.doc(currUser.uid.toString()).update({
        "factor": currUser.factor,
      });
      return true;
    } catch (e) {
      return false;
    }
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

  Future<List<OtherUser>?> otherUsersListFromFireStore(String uid) async {
    try {
      List<OtherUser> req = [];
      await userData.get().then((QuerySnapshot querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          if (doc.id != uid) {
            req.add(OtherUser(
                uid: doc.id,
                name: doc["name"],
                email: doc["email"],
                likedGames: doc["likedGames"].cast<int>().toSet()));
          }
        }
      });
      return req;
    } on Exception catch (e) {
      return null;
    }
  }

  Future<List<Game>?> gameListFromSnapshot([Set<int>? tp]) async {
    try {
      List<Game> req = [];
      await gameData.get().then((QuerySnapshot querySnapshot) async {
        if (tp == null) {
          for (var doc in querySnapshot.docs) {
            req.add(Game(
                id: doc["id"],
                name: doc["name"],
                description: doc["description"],
                url: doc["url"],
                tags: doc["tags"]));
          }
        } else {
          for (var doc in querySnapshot.docs) {
            if (tp.contains(doc["id"] as int)) {
              req.add(Game(
                  id: doc["id"],
                  name: doc["name"],
                  description: doc["description"],
                  url: doc["url"],
                  tags: doc["tags"]));
            }
          }
        }
      });
      return req;
    } on Exception catch (e) {
      return null;
    }
  }

  Future<List<Game>?> recommendationListFromSnapshot(
      List<dynamic> data, Set<int> likedGames) async {
    try {
      List<Game> req = [];
      var max = data[data.length - 1][1];
      for (var ar in data) {
        int id = ar[0].round();
        if (!likedGames.contains(id)) {
          DocumentSnapshot doc = await gameData.doc(id.toString()).get();
          Game temp = Game(
              id: doc["id"],
              name: doc["name"],
              description: doc["description"],
              url: doc["url"],
              tags: doc["tags"]);
          temp.score = (100 - ar[1] * 100 / max).round().toString();
          req.add(temp);
        }
      }
      return req;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> setFireStoreGameData(List<dynamic> data) async {
    int l = 22, r = 100;
    for (var ar in data) {
      int id = ar[2];
      if (id >= l && id <= r) 
      gameData.doc(id.toString()).set({
        "id": id,
        "name": ar[0],
        "tags": ar[1],
        "description": "",
        "url": await gameImageUrlGen(id),
      });
    }
  }

  Future<String> gameImageUrlGen(int id) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('images/${id.toString()}.png')
        .getDownloadURL();
    return downloadURL;
  }
}
