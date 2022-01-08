import 'package:flutter/material.dart';
import 'package:frontend/API/django_api.dart';
import 'package:frontend/Widgets/game_tile.dart';
import 'package:frontend/Widgets/misc_widgets.dart';
import 'package:frontend/models/game.dart';
import 'package:frontend/models/user.dart';

// ignore: must_be_immutable
class RecommenderScreen extends StatefulWidget {
  RecommenderScreen({Key? key, required this.currUser}) : super(key: key);
  user currUser;
  @override
  _RecommenderScreenState createState() => _RecommenderScreenState();
}

class _RecommenderScreenState extends State<RecommenderScreen> {
  void trigger() {}

  @override
  Widget build(BuildContext context) {
    Future<List<Game>?> gamesList = getRecommendations(widget.currUser);
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
                return const Center(child: LoadingWidget());
              }
            },
          ),
        ),
      ],
    );
  }
}
