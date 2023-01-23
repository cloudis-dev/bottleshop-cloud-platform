import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/feature_section/feature_card.dart';
import 'package:flutter/material.dart';
import 'package:delivery/l10n/l10n.dart';

class FeatureMobileSection extends StatelessWidget {
  FeatureMobileSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Container(
              width: 300,
              child: Text(context.l10n.customerSatisfaction.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: publicSansTextTheme.bodyText1)),
          Container(
            padding: EdgeInsets.only(top: 20),
            width: 400,
            child: Text(
              context.l10n.bringTopQuality,
              textAlign: TextAlign.center,
              style: libreBodoniTextTheme.headline3,
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: FeatureCard(
              imgPath: kExclusiveIcon,
              headline: context.l10n.premiumBrands,
              txt: context.l10n.highestQualityBrands,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: FeatureCard(
              imgPath: kGiftsIcon,
              headline: context.l10n.giftsForDemandingPeople,
              txt: context.l10n.surpriseLovedOnes,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: FeatureCard(
              imgPath: kCareIcon,
              headline: context.l10n.extraordinaryAccess,
              txt: context.l10n.tenYearAccess,
              fontSize: 20,
            ),
          ),
          FeatureCard(
            imgPath: kMobilePhoneIcon,
            headline: context.l10n.mobileApplication,
            txt: context.l10n.downloadFreeMobileApp,
            fontSize: 20,
          ),
        ],
      ),
    );
  }
}
