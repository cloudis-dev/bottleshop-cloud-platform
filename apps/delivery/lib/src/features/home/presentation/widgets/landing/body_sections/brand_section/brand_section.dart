import 'package:delivery/src/core/data/res/constants.dart';
import 'package:flutter/material.dart';

class BrandSection extends StatelessWidget {
  BrandSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 235, vertical: 54),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            kBelugaIcon,
            width: 150.12,
            height: 80,
          ),
          Image.asset(
            kDiplomaticoIcon,
            width: 150.12,
            height: 80,
          ),
          Image.asset(
            kMurrayMcDavidIcon,
            width: 150.12,
            height: 80,
          ),
          Image.asset(
            kRemyMartinIcon,
            width: 150.12,
            height: 80,
          ),
        ],
      ),
    );
  }
}
