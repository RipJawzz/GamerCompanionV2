import 'package:flutter/material.dart';
import 'package:frontend/Widgets/user_page.dart';
import 'package:frontend/models/otherUsers.dart';
import 'package:frontend/models/user.dart';

class UserTile extends StatefulWidget {
  UserTile(
      {Key? key,
      required this.selectedUser,
      required this.currUser,
      required this.trigger})
      : super(key: key);
  OtherUser selectedUser;
  user currUser;
  Function trigger;

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(9.0),
        color: Colors.tealAccent[400],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.selectedUser.name,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              widget.selectedUser.email,
              style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserPage(
                  selectedUser: widget.selectedUser,
                  currUser: widget.currUser)),
        ).then((value) => widget.trigger());
      },
    );
  }
}
