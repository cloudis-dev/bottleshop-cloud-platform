import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/buttons.dart';
import 'package:delivery/src/features/products/presentation/pages/category_products_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:delivery/l10n/l10n.dart';

class WhiskeyMobileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: <Widget>[
      Align(
          alignment: Alignment.topRight,
          child: Image.asset(
            kLandingImage3Mobile,
            height: 606,
            fit: BoxFit.fitHeight,
          )),
      Align(
          alignment: Alignment.topRight,
          child: Image.asset(
            kBlackGradient3Mobile,
            height: 606,
            fit: BoxFit.fitHeight,
          )),
      Column(
        children: [
          Text(
            context.l10n.forTheDemanding.toUpperCase(),
            style: publicSansTextTheme.headline3,
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            context.l10n.whiskey,
            style: libreBodoniTextTheme.headline3,
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: 400,
            child: Text(context.l10n.whiskeyParagraph,
                textAlign: TextAlign.center,
                style: publicSansTextTheme.caption),
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(
              width: 262,
              child: LandingPageButton(
                txt: context.l10n.goToWhiskeys,
                nestingBranch: NestingBranch.categories,
                routebornPage:
                    CategoryProductsPage.uid(categoryUidStrings.whiskey),
                btnFontSize: 18,
              )),
        ],
      ),
    ]);
  }
}
