import 'package:flutter/material.dart';
import 'package:frontend/Firebase/database.dart';
import 'package:frontend/Widgets/misc_widgets.dart';
import 'package:frontend/Widgets/user_tile.dart';
import 'package:frontend/models/otherUsers.dart';
import 'package:frontend/models/user.dart';

class SocialPage extends StatefulWidget {
  SocialPage({Key? key, required this.currUser}) : super(key: key);
  user currUser;
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  String tab = "All Users";

  Future<List<OtherUser>?> listSwitcher() {
    switch (tab) {
      case "Following":
        return Database().otherUsersListFromFireStore(
            widget.currUser.uid, widget.currUser.following);
      default:
        return Database().otherUsersListFromFireStore(widget.currUser.uid);
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
    Future<List<OtherUser>?> otherUserList = listSwitcher();
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FutureBuilder(
            future: otherUserList,
            builder: (BuildContext context,
                AsyncSnapshot<List<OtherUser>?> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const EmptyPage();
                }
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, index) {
                      return UserTile(
                          selectedUser: snapshot.data![index],
                          currUser: widget.currUser,
                          trigger: trigger);
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
            navSwitch("All Users"),
            navSwitch("Following"),
          ],
        ),
      ],
    );
  }
}
