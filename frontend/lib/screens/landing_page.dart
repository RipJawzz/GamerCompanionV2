import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: const [
        Expanded(
          child: Center(
            child: Hero(
              tag: "razer Logo",
              child: Image(
                image: AssetImage("assets/images/general/razer.png"),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
