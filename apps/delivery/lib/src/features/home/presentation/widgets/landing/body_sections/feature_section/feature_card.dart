import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeatureCard extends StatelessWidget {
  final String imgPath;
  final String headline;
  final String txt;
  double fontSize;

  FeatureCard(
      {super.key,
      required this.imgPath,
      required this.headline,
      required this.txt,
      this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imgPath,
            width: fontSize * 5,
            height: fontSize * 5,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8, top: fontSize),
            child: Text(
              headline,
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor),
            ),
          ),
          Text(
            txt,
            textAlign: TextAlign.center,
            style: GoogleFonts.publicSans(
              fontSize: fontSize - 2,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
