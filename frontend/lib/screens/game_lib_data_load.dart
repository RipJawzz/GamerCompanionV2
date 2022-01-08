import 'package:flutter/material.dart';
import 'package:frontend/Firebase/database.dart';
import 'package:frontend/Widgets/misc_widgets.dart';
import 'package:frontend/models/game.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/games_library.dart';

// ignore: must_be_immutable
class GameLibraryDataLoadScreen extends StatefulWidget {
  GameLibraryDataLoadScreen({Key? key, required this.currUser})
      : super(key: key);
  user currUser;
  @override
  _DataLoadScreenState createState() => _DataLoadScreenState();
}

class _DataLoadScreenState extends State<GameLibraryDataLoadScreen> {
  @override
  Widget build(BuildContext context) {
    Future<List<Game>?> gamesList = Database().gameListFromSnapshot();
    return FutureBuilder(
        future: gamesList,
        builder: (BuildContext context, AsyncSnapshot<List<Game>?> snapshot) {
          if (snapshot.hasData) {
            return GamesLibrary(
                currUser: widget.currUser,
                completeList: snapshot.data as List<Game>);
          } else if (snapshot.hasError) {
            return const ErrorDisplay();
          } else {
            return const Center(
              child: LoadingWidget(),
            );
          }
        });
  }
}
