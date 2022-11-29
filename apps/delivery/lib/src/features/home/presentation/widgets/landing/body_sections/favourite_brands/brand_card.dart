import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandCard extends StatelessWidget {
  final String imgPath;
  final String headline;
  final String txt;

  BrandCard(
      {super.key,
      required this.imgPath,
      required this.headline,
      required this.txt});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Image.asset(
                kBrandBackground,
                width: 160,
                height: 160,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32, left: 10),
                child: Image.asset(
                  imgPath,
                  width: 140,
                  height: 146,
                ),
              ),
            ],
          ),
          Text(headline.toUpperCase(),
              textAlign: TextAlign.center,
              style: publicSansTextTheme.headline3),
          SizedBox(
            height: 10,
          ),
          Text(txt,
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                  fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
