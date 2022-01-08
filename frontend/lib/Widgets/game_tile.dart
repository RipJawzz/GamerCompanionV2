import 'package:flutter/material.dart';
import 'package:frontend/Widgets/game_page.dart';
import 'package:frontend/models/game.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/models/user.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.only(top: 8, bottom: 4, left: 2, right: 2),
      color: Colors.grey[850],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.game.name,
                  style: GoogleFonts.lato(fontSize: 15, color: Colors.white),
                ),
                if (widget.game.score != null)
                  Text(
                    widget.game.score! + " %",
                    style: GoogleFonts.lato(fontSize: 15, color: Colors.white),
                  ),
              ],
            ),
          ),
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
