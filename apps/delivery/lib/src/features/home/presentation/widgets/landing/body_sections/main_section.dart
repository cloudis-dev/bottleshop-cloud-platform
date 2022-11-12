import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:delivery/l10n/l10n.dart';

class MainSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Align(
          alignment: Alignment.topRight,
          child: Image.asset(
            kLandingImage1,
            width: 1118,
            height: 606,
          )),
      Container(
          width: double.infinity,
          height: 608,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset.centerLeft,
                end: FractionalOffset.centerRight,
                colors: <Color>[
                  Color.fromRGBO(11, 11, 11, 1),
                  Color.fromRGBO(12, 13, 13, 0.892533),
                  Color.fromRGBO(14, 14, 14, 0.808487),
                  Color.fromRGBO(28, 29, 29, 0),
                ],
                stops: [
                  0.2412,
                  0.3448,
                  0.5285,
                  0.9995,
                ]),
          )),
      Positioned(
        top: 177,
        left: 256,
        width: 636,
        child: Text(
          context.l10n.luxuriousSpirits,
          style: GoogleFonts.libreBodoni(
              fontSize: 70, fontWeight: FontWeight.w400),
        ),
      ),
      Positioned(
          top: 385,
          left: 256,
          child: LandingPageButton(
            txt: context.l10n.showMore,
            nestingBranch: NestingBranch.shop,
          )),
    ]);
  }
}
