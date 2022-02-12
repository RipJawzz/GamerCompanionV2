import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/API/django_api.dart';
import 'package:frontend/Firebase/database.dart';
import 'package:frontend/Widgets/misc_widgets.dart';
import 'package:frontend/models/game.dart';
import 'package:frontend/models/user.dart';

// ignore: must_be_immutable
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: genreListGen(widget.game.tags.split("|")),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    widget.game.description,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
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
                    toggleGamePref(widget.currUser, id,
                        widget.currUser.likedGames.contains(id));
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
