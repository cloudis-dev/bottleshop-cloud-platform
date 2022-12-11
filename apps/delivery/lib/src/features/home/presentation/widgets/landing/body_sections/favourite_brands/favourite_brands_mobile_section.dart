import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/favourite_brands/brand_card.dart';
import 'package:flutter/material.dart';
import 'package:delivery/l10n/l10n.dart';

class FavouriteBrandsMobileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Column(
          children: [
            Container(
              width: 400,
              child: Text(context.l10n.favoriteBrandsInOnePlace,
                  textAlign: TextAlign.center,
                  style: libreBodoniTextTheme.headline3),
            ),
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: BrandCard(
                  imgPath: kWhiskeyBourbon,
                  headline: context.l10n.whiskeyBourbon,
                  txt: "Balvenie, Kilchoman, Glenmorangie...",
                  category: categoryUidStrings.whiskey),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: BrandCard(
                  imgPath: kCognac,
                  headline: context.l10n.cognac,
                  txt: "Mery Melrose, Hennessy, Lheraud...",
                  category: categoryUidStrings.cognac),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: BrandCard(
                  imgPath: kRum,
                  headline: context.l10n.rum,
                  txt: "Diplomatico, Centenario, A.H. Riise...",
                  category: categoryUidStrings.rum),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: BrandCard(
                  imgPath: kVodka,
                  headline: context.l10n.vodka,
                  txt: "Beluga, Russian Standard, Belvedere...",
                  category: categoryUidStrings.vodka),
            ),
            BrandCard(
                imgPath: kGin,
                headline: context.l10n.gin,
                txt: "Hendricks, Bulldog, Nikka...",
                category: categoryUidStrings.gin),
          ],
        ));
  }
}
