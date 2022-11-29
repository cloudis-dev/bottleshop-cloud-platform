import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/favourite_brands/brand_card.dart';
import 'package:flutter/material.dart';
import 'package:delivery/l10n/l10n.dart';

class FavouriteBrandsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 265, vertical: 100),
      child: Column(
        children: [
          Text(context.l10n.favoriteBrandsInOnePlace,
              style: libreBodoniTextTheme.headline3),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BrandCard(
                  imgPath: kWhiskeyBourbon,
                  headline: context.l10n.whiskeyBourbon,
                  txt: "Balvenie, Kilchoman, Glenmorangie..."),
              BrandCard(
                  imgPath: kCognac,
                  headline: context.l10n.cognac,
                  txt: "Mery Melrose, Hennessy, Lheraud..."),
              BrandCard(
                  imgPath: kRum,
                  headline: context.l10n.rum,
                  txt: "Diplomatico, Centenario, A.H. Riise..."),
              BrandCard(
                  imgPath: kVodka,
                  headline: context.l10n.vodka,
                  txt: "Beluga, Russian Standard, Belvedere..."),
              BrandCard(
                  imgPath: kGin,
                  headline: context.l10n.gin,
                  txt: "Hendricks, Bulldog, Nikka..."),
            ],
          )
        ],
      ),
    );
  }
}
