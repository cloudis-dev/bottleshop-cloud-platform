import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/buttons.dart';
import 'package:delivery/src/features/products/presentation/pages/category_products_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:delivery/l10n/l10n.dart';

class RumSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Align(
          alignment: Alignment.topLeft,
          child: Image.asset(
            kLandingImage2,
            width: 756,
            height: 606,
          )),
      Positioned(
        left: 336,
        child: Container(
            width: 448,
            height: 608,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: FractionalOffset.centerLeft,
                  end: FractionalOffset.centerRight,
                  colors: <Color>[
                    Color.fromRGBO(0, 0, 0, 0),
                    Color.fromRGBO(9, 9, 9, 0.709975),
                    Color.fromRGBO(12, 12, 12, 0.959272),
                    Color(0xff0C0C0C),
                  ],
                  stops: [
                    0.1655,
                    0.4997,
                    0.6459,
                    0.7694,
                  ]),
            )),
      ),
      Positioned(
        left: 825,
        top: 200,
        child: Container(
          width: 360,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.discoverTheUnknown.toUpperCase(),
                style: publicSansTextTheme.bodyText1,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Text(
                  context.l10n.rum,
                  style: libreBodoniTextTheme.headline2,
                ),
              ),
              Text(context.l10n.rumParagraph,
                  style: publicSansTextTheme.caption),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: SizedBox(
                    width: 216,
                    child: LandingPageButton(
                      txt: context.l10n.goToRums,
                      nestingBranch: NestingBranch.categories,
                      routebornPage:
                          CategoryProductsPage.uid(categoryUidStrings.rum),
                    )),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
