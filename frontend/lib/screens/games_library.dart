import 'package:flutter/material.dart';
import 'package:frontend/Firebase/database.dart';
import 'package:frontend/Widgets/game_tile.dart';
import 'package:frontend/Widgets/misc_widgets.dart';
import 'package:frontend/models/game.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/home_screen.dart';

class GamesLibrary extends StatefulWidget {
  GamesLibrary({Key? key, required this.currUser}) : super(key: key);
  user currUser;
  @override
  _GamesLibraryState createState() => _GamesLibraryState();
}

class _GamesLibraryState extends State<GamesLibrary> {
  String tab = "allGames";

  Future<List<Game>?> listSwitcher() {
    switch (tab) {
      case "likedGames":
        return Database().gameListFromSnapshot(widget.currUser.likedGames);
      default:
        return Database().gameListFromSnapshot();
    }
  }

  Widget navSwitch(String title) {
    return TextButton(
      onPressed: () {
        tab = title;
        setState(() {});
      },
      child: Text(
        title,
        style: TextStyle(
          color: tab == title ? Colors.black : Colors.white,
          backgroundColor:
              tab == title ? Colors.white : Theme.of(context).backgroundColor,
        ),
      ),
    );
  }

  void trigger() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Game>?> gamesList = listSwitcher();
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            navSwitch("allGames"),
            navSwitch("likedGames"),
          ],
        ),
      ],
    );
  }
}
