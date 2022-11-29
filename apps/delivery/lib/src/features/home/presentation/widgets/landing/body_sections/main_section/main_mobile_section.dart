import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/buttons.dart';
import 'package:flutter/material.dart';
import 'package:delivery/l10n/l10n.dart';

class MainMobileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: <Widget>[
      Align(
          alignment: Alignment.topRight,
          child: Image.asset(kLandingImage1Mobile,
              width: double.infinity, fit: BoxFit.fitWidth)),
      Container(
          width: double.infinity,
          height: 505.5,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset.centerLeft,
                end: FractionalOffset.centerRight,
                colors: <Color>[
                  Color.fromRGBO(11, 11, 11, 1),
                  Color.fromRGBO(12, 13, 13, 0.892533),
                  Color.fromRGBO(14, 14, 14, 0.808487),
                  Color.fromRGBO(28, 29, 29, 0),
                ],
                stops: [
                  0.2412,
                  0.3448,
                  0.5285,
                  0.9995,
                ]),
          )),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.l10n.luxuriousSpirits,
            style: libreBodoniTextTheme.headline1,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 40,
          ),
          Container(
              width: 222,
              child: LandingPageButton(
                txt: context.l10n.showMore,
                nestingBranch: NestingBranch.shop,
                btnFontSize: 18,
              ))
        ],
      )
    ]);
  }
}
