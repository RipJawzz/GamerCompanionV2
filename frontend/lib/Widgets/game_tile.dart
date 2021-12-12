import 'package:flutter/material.dart';
import 'package:frontend/Widgets/game_page.dart';
import 'package:frontend/models/game.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/models/user.dart';

class GameTile extends StatefulWidget {
  GameTile(
      {Key? key,
      required this.game,
      required this.currUser,
      required this.trigger})
      : super(key: key);
  final Game game;
  user currUser;
  Function trigger;
  @override
  _GameTileState createState() => _GameTileState();
}

class _GameTileState extends State<GameTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(9.0),
      color: Colors.tealAccent[400],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(widget.game.name),
          Hero(
            tag: "gameImage/" + widget.game.id.toString(),
            child: GestureDetector(
              child: CachedNetworkImage(
                imageUrl: widget.game.url,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(
                        color: Colors.red, value: downloadProgress.progress),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GamePage(
                          game: widget.game, currUser: widget.currUser)),
                ).then((value) => widget.trigger());
              },
            ),
          )
        ],
      ),
    );
  }
}
