import 'package:delivery/src/core/data/res/constants.dart';
import 'package:flutter/material.dart';

class BrandSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 200, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            kBelugaIcon,
            width: 142.22,
            fit: BoxFit.fitWidth,
          ),
          Image.asset(
            kDiplomaticoIcon,
            width: 150.12,
            fit: BoxFit.fitWidth,
          ),
          Image.asset(
            kMurrayMcDavidIcon,
            width: 176.64,
            fit: BoxFit.fitWidth,
          ),
          Image.asset(
            kRemyMartinIcon,
            width: 190.44,
            fit: BoxFit.fitWidth,
          ),
        ],
      ),
    );
  }
}
