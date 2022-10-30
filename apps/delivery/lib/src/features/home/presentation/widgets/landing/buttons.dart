import 'package:delivery/src/core/data/res/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

class LandingPageButton extends StatelessWidget {
  final String txt;

  const LandingPageButton({super.key, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Color.fromRGBO(191, 138, 36, 1)),
            bottom:
                BorderSide(width: 1.0, color: Color.fromRGBO(191, 138, 36, 1)),
          ),
        ),
        child: TextButton(
          onPressed: () {},
          child: Padding(
              padding:
                  EdgeInsets.only(left: 16, top: 12, bottom: 12, right: 16),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    txt.toUpperCase(),
                    style: GoogleFonts.publicSans(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                Image.asset(
                  kBtnArrow,
                  width: 37,
                  fit: BoxFit.fitHeight,
                ),
              ])),
        ));
  }
}
