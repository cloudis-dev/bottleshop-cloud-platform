import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:delivery/l10n/l10n.dart';

class WhiskeySection extends StatelessWidget {
  WhiskeySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Align(
          alignment: Alignment.topRight,
          child: Image.asset(
            kLandingImage3,
            width: 743,
            height: 606,
          )),
      Positioned(
        right: 388,
        child: Container(
            width: 486,
            height: 608,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: FractionalOffset.centerRight,
                  end: FractionalOffset.centerLeft,
                  colors: <Color>[
                    Color.fromRGBO(0, 0, 0, 0),
                    Color.fromRGBO(9, 9, 9, 0.709975),
                    Color.fromRGBO(12, 12, 12, 0.959272),
                    Color(0xff0C0C0C),
                  ],
                  stops: [
                    0.1655,
                    0.4997,
                    0.6459,
                    0.7694,
                  ]),
            )),
      ),
      Positioned(
        left: 257,
        top: 211,
        child: Container(
          width: 360,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.forTheDemanding.toUpperCase(),
                style: GoogleFonts.publicSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffBF8A24)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Text(
                  context.l10n.whiskey,
                  style: GoogleFonts.libreBodoni(
                      fontSize: 45,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
              Text(context.l10n.whiskeyParagraph,
                  style: GoogleFonts.publicSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: SizedBox(
                    width: 240,
                    child: LandingPageButton(txt: context.l10n.goToWhiskeys)),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
