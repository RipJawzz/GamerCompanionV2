import 'package:flutter/material.dart';
import 'package:frontend/Shared/constants.dart';
import 'package:frontend/Widgets/game_tile.dart';
import 'package:frontend/Widgets/misc_widgets.dart';
import 'package:frontend/models/game.dart';
import 'package:frontend/models/user.dart';

// ignore: must_be_immutable
class GamesLibrary extends StatefulWidget {
  GamesLibrary({Key? key, required this.currUser, required this.completeList})
      : super(key: key);
  user currUser;
  List<Game> completeList;
  @override
  _GamesLibraryState createState() => _GamesLibraryState();
}

class _GamesLibraryState extends State<GamesLibrary> {
  String tab = "allGames", searchSubstr = "";
  bool search = false;
  List<Game> reqList = [];
  List<Game> listModifier() {
    List<Game> initialScreening = [];
    if (search) {
      for (var game in widget.completeList) {
        if (game.name.toLowerCase().contains(searchSubstr.toLowerCase())) {
          initialScreening.add(game);
        }
      }
    } else {
      initialScreening = widget.completeList;
    }
    List<Game> temp = [];
    switch (tab) {
      case "likedGames":
        for (var game in initialScreening) {
          if (widget.currUser.likedGames.contains(game.id)) {
            temp.add(game);
          }
        }
        return temp;
      default:
        return temp = initialScreening;
    }
  }

  Widget navSwitch(String title) {
    return TextButton(
      onPressed: () {
        tab = title;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(15.0),
            ),
            color:
                tab == title ? Colors.white : Theme.of(context).primaryColor),
        child: Text(
          title,
          style: TextStyle(
            color: tab == title ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  void trigger() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    reqList = listModifier();
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (search)
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              decoration: textInputDecoration,
              cursorColor: Colors.white,
              onChanged: (text) {
                setState(() {
                  searchSubstr = text;
                });
              },
            ),
          ),
        Flexible(
            child: (reqList.isEmpty)
                ? const EmptyPage()
                : ListView.builder(
                    itemCount: reqList.length,
                    itemBuilder: (BuildContext context, index) {
                      return GameTile(
                        game: reqList[index],
                        currUser: widget.currUser,
                        trigger: trigger,
                      );
                    })),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            navSwitch("allGames"),
            navSwitch("likedGames"),
            IconButton(
                onPressed: () {
                  setState(() {
                    search = !search;
                    searchSubstr = "";
                  });
                },
                icon: Icon(Icons.search,
                    color: search ? Colors.red : Colors.green)),
          ],
        ),
      ],
    );
  }
}
