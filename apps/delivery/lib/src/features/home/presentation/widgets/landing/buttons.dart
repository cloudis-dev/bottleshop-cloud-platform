import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class Btns extends StatelessWidget {
  final String txt;
  const Btns({Key? key, required this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
      child: TextButton(
        onPressed: () {},
        child: Text(
          txt,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }
}

class Link extends StatelessWidget {
  final String txt;
  const Link({Key? key, required this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextButton(
        onPressed: () {},
        child: Text(txt, style: Theme.of(context).textTheme.headline5),
      ),
    );
  }
}