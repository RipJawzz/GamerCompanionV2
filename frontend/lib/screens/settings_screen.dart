import 'package:flutter/material.dart';
import 'package:frontend/Firebase/database.dart';
import 'package:frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key, required this.currUser}) : super(key: key);
  user currUser;
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.all(Radius.circular(15.0))),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Learning Rate",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0))),
                    child: TextButton(
                        onPressed: () async {
                          var fin = await Database()
                              .updateUserFactor(widget.currUser);

                          if (fin) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Pref updated to ${widget.currUser.factor}!"),
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text("Pref updating failed."),
                              backgroundColor: Theme.of(context).errorColor,
                            ));
                          }
                        },
                        child: Text("Set ${widget.currUser.factor}")),
                  )
                ],
              ),
              const Text(
                "This affects how quickly your recommendations change based on your recently liked games. A value of 100 means you will recieve recommendations based only on your most recently like games, and a value of 10 means recenlty liked 15~21 games are considered for recommendations",
                style: TextStyle(color: Colors.white),
              ),
              Slider(
                value: widget.currUser.factor * 1.0,
                onChanged: (value) {
                  setState(() {
                    widget.currUser.factor = value.round();
                  });
                },
                label: widget.currUser.factor.round().toString(),
                divisions: 9,
                min: 10,
                max: 100,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.all(Radius.circular(15.0))),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius:
                        const BorderRadius.all(Radius.circular(15.0))),
                child: TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('saved', false);
                    Navigator.pushReplacementNamed(context, "/");
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
