import 'package:flutter/material.dart';
import 'package:frontend/Shared/constants.dart';
import 'package:frontend/Widgets/misc_widgets.dart';
import 'package:frontend/Widgets/user_tile.dart';
import 'package:frontend/models/other_users.dart';
import 'package:frontend/models/user.dart';

// ignore: must_be_immutable
class SocialPage extends StatefulWidget {
  SocialPage({Key? key, required this.currUser, required this.completeList})
      : super(key: key);
  user currUser;
  List<OtherUser> completeList;
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  String tab = "All Users", searchSubstr = "";
  bool search = false;
  List<OtherUser> reqList = [];
  List<OtherUser> listModifier() {
    List<OtherUser> initialScreening = [];
    if (search) {
      for (var userItr in widget.completeList) {
        if (userItr.name.toLowerCase().contains(searchSubstr.toLowerCase())) {
          initialScreening.add(userItr);
        }
      }
    } else {
      initialScreening = widget.completeList;
    }
    List<OtherUser> temp = [];
    switch (tab) {
      case "Following":
        for (var userItr in initialScreening) {
          if (widget.currUser.following.contains(userItr.uid)) {
            temp.add(userItr);
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
                      return UserTile(
                          selectedUser: reqList[index],
                          currUser: widget.currUser,
                          trigger: trigger);
                    })),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            navSwitch("All Users"),
            navSwitch("Following"),
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
