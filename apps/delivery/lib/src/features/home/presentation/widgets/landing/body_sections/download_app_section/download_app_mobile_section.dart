import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/download_app_section/app_feature_row.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DownloadAppMobileSection extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(
      sharedPreferencesProvider.select((value) => value.getAppLanguage()),
    );
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: kPrimaryColor,
        ),
        child: Stack(alignment: Alignment.center, children: [
          Positioned(
            top: 0,
            child: Image.asset(kBlackGradient4Mobile, fit: BoxFit.fitWidth),
          ),
          Column(children: [
            Container(
              padding: EdgeInsets.only(top: 80, bottom: 40),
              width: 400,
              child: Text(
                context.l10n.doNotHaveMobileApp,
                textAlign: TextAlign.center,
                style: GoogleFonts.libreBodoni(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff0C0C0C)),
              ),
            ),
            Stack(alignment: Alignment.center, children: [
              Image.asset(
                kAppBackground,
                width: 241.05,
                fit: BoxFit.fitWidth,
              ),
              Image.asset(
                kApp,
                width: 216.95,
                fit: BoxFit.fitWidth,
              ),
            ]),
            SizedBox(
              height: 30,
            ),
            TextButton(
                style: TextButton.styleFrom(
                    minimumSize: Size.zero, padding: EdgeInsets.zero),
                child: (language == LanguageMode.en)
                    ? Image.asset(kAppStoreBadgeEn,
                        width: 200, fit: BoxFit.contain)
                    : Image.asset(kAppStoreBadgeSk,
                        width: 200, fit: BoxFit.contain),
                onPressed: () {
                  launchUrlString(UrlStrings.appStore);
                }),
            SizedBox(
              height: 10,
            ),
            TextButton(
                style: TextButton.styleFrom(
                    minimumSize: Size.zero, padding: EdgeInsets.zero),
                child: (language == LanguageMode.en)
                    ? Image.asset(kGooglePlayBadgeEn,
                        width: 230, fit: BoxFit.contain)
                    : Image.asset(kGooglePlayBadgeSk,
                        width: 200, fit: BoxFit.contain),
                onPressed: () {
                  launchUrlString(UrlStrings.googlePlay);
                }),
            SizedBox(
              height: 18.5,
            ),
            Container(
                width: 305,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: AppFeatureRow(
                        imgPath: kWhiteShoppingCartIcon,
                        txt: context.l10n.orderFromHome,
                        txtColor: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    AppFeatureRow(
                      imgPath: kWhiteHeartIcon,
                      txt: context.l10n.saveItemsToFavorites,
                      txtColor: Colors.white,
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    AppFeatureRow(
                      imgPath: kWhiteCouponIcon,
                      txt: context.l10n.latestPromotions,
                      txtColor: Colors.white,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      context.l10n.downloadAppEnjoyBenefits,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.publicSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ))
          ])
        ]));
  }
}
