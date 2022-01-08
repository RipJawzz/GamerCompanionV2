import 'package:flutter/material.dart';
import 'package:frontend/Widgets/misc_widgets.dart';
import 'package:frontend/screens/game_lib_data_load.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/landing_page.dart';
import 'package:frontend/screens/recommender_screen.dart';
import 'package:frontend/screens/settings_screen.dart';
import 'package:frontend/screens/socials_data_load.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.currUser}) : super(key: key);
  final user currUser;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String screen = "main";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/");
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(titleSwitch(screen)),
        ),
        body: screenSwitch(screen, widget.currUser),
        drawer: Drawer(
          child: ListView(
            children: [
              const Image(
                image: AssetImage("assets/images/general/drawer.png"),
              ),
              div(),
              drawerTile("Games Library", Icons.games),
              div(),
              drawerTile("Recommender", Icons.local_fire_department),
              div(),
              drawerTile("Socials", Icons.person),
              div(),
              drawerTile("Messages", Icons.message),
              div(),
              drawerTile("Settings", Icons.settings),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerTile(String screenName, var icon) {
    return ListTile(
      leading: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
      title: Text(
        screenName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        screen = screenName;
        setState(() {});
        Navigator.pop(context);
      },
    );
  }
}

String titleSwitch(String screen) {
  switch (screen) {
    case "main":
      return "Welcome!";
    case "Games Library":
      return screen;
    case "Recommender":
      return screen;
    case "Socials":
      return screen;
    case "Messages":
      return screen;
    case "Settings":
      return screen;
    default:
      return "Huh! This is weird.";
  }
}

Widget screenSwitch(String screen, user currUser) {
  switch (screen) {
    case "main":
      return const LandingPage();
    case "Games Library":
      return GameLibraryDataLoadScreen(
        currUser: currUser,
      );
    case "Recommender":
      return RecommenderScreen(
        currUser: currUser,
      );
    case "Socials":
      return SocialsDataLoadScreen(
        currUser: currUser,
      );
    case "Settings":
      return SettingsScreen(
        currUser: currUser,
      );
    default:
      return const ComingSoon();
  }
}

Widget div() {
  return const Divider(
    thickness: 0.0,
    indent: 5,
    endIndent: 5,
    color: Colors.grey,
  );
}
