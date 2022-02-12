import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitSpinningLines(
          itemCount: 10,
          size: 200,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }
}

List<Widget> genreListGen(List<String> genres) {
  List<Widget> fin = [];
  for (var g in genres) {
    fin.add(Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Center(
        child: Text(
          g,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    ));
  }
  return fin;
}

void errorSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Theme.of(context).errorColor,
  ));
}

void infoSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Theme.of(context).colorScheme.secondary,
  ));
}
