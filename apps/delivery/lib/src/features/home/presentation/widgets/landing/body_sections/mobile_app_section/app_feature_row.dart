import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFeatureRow extends StatelessWidget {
  final String imgPath;
  final String txt;

  AppFeatureRow({super.key, required this.imgPath, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imgPath,
          width: 24,
          height: 24,
        ),
        SizedBox(
          width: 9,
        ),
        Text(
          txt,
          style: GoogleFonts.publicSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff0C0C0C)),
        ),
      ],
    );
  }
}
