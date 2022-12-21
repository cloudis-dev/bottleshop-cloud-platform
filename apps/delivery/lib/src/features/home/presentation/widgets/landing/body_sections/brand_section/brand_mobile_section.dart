import 'package:delivery/src/core/data/res/constants.dart';
import 'package:flutter/material.dart';

class BrandMobileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            kBelugaIcon,
            width: 86.89,
            fit: BoxFit.fitWidth,
          ),
          Image.asset(
            kDiplomaticoIcon,
            width: 90.05,
            fit: BoxFit.fitWidth,
          ),
          Image.asset(
            kMurrayMcDavidIcon,
            width: 100.66,
            fit: BoxFit.fitWidth,
          ),
          Image.asset(
            kRemyMartinIcon,
            width: 121,
            fit: BoxFit.fitWidth,
          ),
        ],
      ),
    );
  }
}
