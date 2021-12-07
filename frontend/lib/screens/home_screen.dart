import 'package:flutter/material.dart';
import 'package:frontend/Widgets/error_widget.dart';
import 'package:frontend/models/user.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(titleSwitch(screen)),
      ),
      body: screenSwitch(screen),
      drawer: Drawer(
        child: ListView(
          children: [
            const Image(
              image: AssetImage("assets/images/general/drawer.png"),
            ),
            div(),
            ListTile(
              leading: drawerIcons(Icons.add),
              title: drawerOptions("Add?"),
              onTap: () {
                screen = "add";
                setState(() {});
                Navigator.pop(context);
              },
            ),
            div(),
            ListTile(
              leading: drawerIcons(Icons.games),
              title: drawerOptions("Library"),
              onTap: () {
                screen = "Library";
                setState(() {});
                Navigator.pop(context);
              },
            ),
            div(),
            ListTile(
              leading: drawerIcons(Icons.settings),
              title: drawerOptions("Settings"),
              onTap: () {
                screen = "Settings";
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

String titleSwitch(String screen) {
  switch (screen) {
    case "main":
      return "Landing";
    case "add":
      return "Adding";
    default:
      return "Weird Stuff";
  }
}

Widget screenSwitch(String screen) {
  switch (screen) {
    case "main":
      return const Text(
        "Landing Page",
        style: TextStyle(color: Colors.white),
      );
    case "add":
      return const ErrorDisplay();
    default:
      return const Text(
        "Shouldnt have happened",
        style: TextStyle(color: Colors.white),
      );
  }
}

Widget drawerOptions(String content) {
  return Text(
    content,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}

Icon drawerIcons(var selected) {
  return Icon(
    selected,
    size: 20,
    color: Colors.white,
  );
}

Widget div() {
  return const Divider(
    thickness: 0.0,
    indent: 5,
    endIndent: 5,
    color: Colors.grey,
  );
}
