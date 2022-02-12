import 'dart:convert';

import 'package:frontend/Firebase/database.dart';
import 'package:frontend/Shared/credentials.dart' as creds;
import 'package:frontend/models/game.dart';
import 'package:frontend/models/user.dart';
import 'package:http/http.dart' as http;

Future<void> createUser(String firebaseID) async {
  bool pending = true;
  while (pending) {
    await http
        .put(
      Uri.parse(creds.apiPath + '/addUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{"firebaseID": firebaseID}),
    )
        .then((dynamic response) {
      pending = false;
      if (response.statusCode == 200) {
        pending = false;
      }
    });
  }
}

Future<void> deleteUser(String firebaseID) async {
  await http.put(
    Uri.parse(creds.apiPath + '/deleteUser'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{"firebaseID": firebaseID}),
  );
}

Future<void> toggleGamePref(user curr, int gameID, bool add) async {
  bool pending = true;
  while (pending) {
    await http
        .put(
      Uri.parse(creds.apiPath + '/toggle_game_pref/' + (add ? '+' : '-')),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "firebaseID": curr.uid,
        "gameID": gameID,
        "factor": curr.factor,
      }),
    )
        .then((dynamic response) {
      pending = false;
      if (response.statusCode == 200) {
        pending = false;
      }
    });
  }
}

Future<List<Game>?> getRecommendations(user curr) async {
  bool pending = true;
  List<Game>? result;
  while (pending) {
    await http
        .put(
      Uri.parse(creds.apiPath + '/recommend'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "firebaseID": curr.uid.toString(),
      }),
    )
        .then((dynamic response) async {
      pending = false;
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)["recommendations"];
        result = await Database()
            .recommendationListFromSnapshot(data, curr.likedGames);
      }
    });
  }
  return result;
}

Future<void> setGameData() async {
  await http.get(
    Uri.parse(creds.apiPath + '/game_desc'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  ).then((dynamic response) async {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)["data"];
      await Database().setFireStoreGameData(data);
    }
  });
}
