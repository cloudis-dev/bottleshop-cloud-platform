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
          Text(headline,
              textAlign: TextAlign.center,
              style: GoogleFonts.libreBodoni(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffBF8A24))),
          Text(txt,
              textAlign: TextAlign.center,
              style: GoogleFonts.libreBodoni(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
        ],
      ),
    );
  }
}
