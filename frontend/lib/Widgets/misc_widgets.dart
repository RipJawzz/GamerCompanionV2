import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            color: const Color(0XFF202125),
            child: const Center(
              child: Image(
                image: AssetImage("assets/images/general/error.png"),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ComingSoon extends StatelessWidget {
  const ComingSoon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: const [
        Expanded(
          child: Image(
            image: AssetImage("assets/misc/comingSoon.gif"),
          ),
        )
      ],
    );
  }
}

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: const [
        Expanded(
          child: Image(
            image: AssetImage("assets/misc/nothingHere.gif"),
          ),
        )
      ],
    );
  }
}
