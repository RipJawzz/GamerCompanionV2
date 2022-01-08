import 'package:flutter/material.dart';
import 'package:frontend/Firebase/database.dart';
import 'package:frontend/Widgets/misc_widgets.dart';
import 'package:frontend/models/other_users.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/social_page.dart';

// ignore: must_be_immutable
class SocialsDataLoadScreen extends StatefulWidget {
  SocialsDataLoadScreen({Key? key, required this.currUser}) : super(key: key);
  user currUser;

  @override
  _SocialsDataLoadScreenState createState() => _SocialsDataLoadScreenState();
}

class _SocialsDataLoadScreenState extends State<SocialsDataLoadScreen> {
  @override
  Widget build(BuildContext context) {
    Future<List<OtherUser>?> gamesList =
        Database().otherUsersListFromFireStore(widget.currUser.uid);
    return FutureBuilder(
        future: gamesList,
        builder:
            (BuildContext context, AsyncSnapshot<List<OtherUser>?> snapshot) {
          if (snapshot.hasData) {
            return SocialPage(
                currUser: widget.currUser,
                completeList: snapshot.data as List<OtherUser>);
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
