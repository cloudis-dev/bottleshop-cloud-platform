import 'package:flutter/material.dart';

import 'package:delivery/src/core/data/res/constants.dart';

class BrandMobileSection extends StatelessWidget {
  const BrandMobileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
