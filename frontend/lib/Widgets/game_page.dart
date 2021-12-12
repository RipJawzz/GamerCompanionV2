import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Firebase/database.dart';
import 'package:frontend/models/game.dart';
import 'package:frontend/models/user.dart';

class GamePage extends StatefulWidget {
  GamePage({Key? key, required this.game, required this.currUser})
      : super(key: key);
  final Game game;
  user currUser;
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
      ),
      body: ListView(
        children: [
          Hero(
            tag: "gameImage/" + widget.game.id.toString(),
            child: CachedNetworkImage(
              imageUrl: widget.game.url,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Container(
            color: Colors.grey,
            child: Text(widget.game.description),
          ),
          Container(
            color: Colors.grey[950],
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () async {
                    int id = widget.game.id;
                    if (widget.currUser.likedGames.contains(id)) {
                      widget.currUser.likedGames.remove(id);
                    } else {
                      widget.currUser.likedGames.add(id);
                    }
                    Database().updateUserLikedGames(widget.currUser);
                    setState(() {});
                  },
                  icon: Icon(widget.currUser.likedGames.contains(widget.game.id)
                      ? Icons.favorite
                      : Icons.favorite_border),
                  iconSize: 50,
                  color: widget.currUser.likedGames.contains(widget.game.id)
                      ? Colors.red
                      : Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
