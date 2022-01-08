import 'package:flutter/material.dart';
import 'package:frontend/Firebase/database.dart';
import 'package:frontend/models/game.dart';
import 'package:frontend/models/other_users.dart';
import 'package:frontend/models/user.dart';

import 'game_tile.dart';
import 'misc_widgets.dart';

// ignore: must_be_immutable
class UserPage extends StatefulWidget {
  UserPage({Key? key, required this.currUser, required this.selectedUser})
      : super(key: key);
  user currUser;
  OtherUser selectedUser;
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  void trigger() {}

  @override
  Widget build(BuildContext context) {
    Future<List<Game>?> gamesList =
        Database().gameListFromSnapshot(widget.selectedUser.likedGames);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedUser.name),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.selectedUser.email,
            style: const TextStyle(
                fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: FutureBuilder(
              future: gamesList,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Game>?> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const EmptyPage();
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, index) {
                        return GameTile(
                          game: snapshot.data![index],
                          currUser: widget.currUser,
                          trigger: trigger,
                        );
                      });
                } else if (snapshot.hasError) {
                  return const ErrorDisplay();
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black,
                      color: Colors.blue,
                    ),
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () async {
                  String id = widget.selectedUser.uid;
                  if (widget.currUser.following.contains(id)) {
                    widget.currUser.following.remove(id);
                  } else {
                    widget.currUser.following.add(id);
                  }
                  Database().updateUserFollowing(widget.currUser);
                  setState(() {});
                },
                icon: Icon(
                    widget.currUser.following.contains(widget.selectedUser.uid)
                        ? Icons.group
                        : Icons.group_add_outlined),
                iconSize: 50,
                color:
                    widget.currUser.following.contains(widget.selectedUser.uid)
                        ? Colors.white
                        : Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
