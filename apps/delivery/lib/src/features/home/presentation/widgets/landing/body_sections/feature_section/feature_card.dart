import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String imgPath;
  final String headline;
  final String txt;

  FeatureCard(
      {super.key,
      required this.imgPath,
      required this.headline,
      required this.txt});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imgPath,
            width: 80,
            height: 80,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 17.5),
            child: Text(headline, textAlign: TextAlign.center),
          ),
          Text(txt, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
