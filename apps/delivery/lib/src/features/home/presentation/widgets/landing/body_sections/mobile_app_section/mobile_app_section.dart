import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/mobile_app_section/app_feature_row.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MobileAppSection extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(
      sharedPreferencesProvider.select((value) => value.getAppLanguage()),
    );
    return Stack(children: [
      Container(
        height: 606,
        decoration: const BoxDecoration(
          color: Color(0xffBF8A24),
        ),
      ),
      Container(
        height: 607,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: <Color>[
                Color.fromRGBO(12, 12, 12, 0),
                Color(0xff0C0C0C),
              ],
              stops: [
                0.0697,
                1,
              ]),
        ),
      ),
      Positioned(
          top: 105,
          left: 255,
          child: Image.asset(
            kAppBackground,
            width: 181.05,
            height: 373.32,
          )),
      Positioned(
          top: 112.71,
          left: 264.28,
          child: Image.asset(
            kApp,
            width: 162.95,
            height: 357.12,
          )),
      Positioned(
          left: 540,
          top: 135,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.doNotHaveMobileApp,
                style: GoogleFonts.libreBodoni(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff0C0C0C)),
              ),
              SizedBox(
                height: 18.5,
              ),
              AppFeatureRow(
                  imgPath: kShoppingCartIcon, txt: context.l10n.orderFromHome),
              SizedBox(
                height: 13,
              ),
              AppFeatureRow(
                  imgPath: kHeartIcon, txt: context.l10n.saveItemsToFavorites),
              SizedBox(
                height: 13,
              ),
              AppFeatureRow(
                  imgPath: kCouponIcon, txt: context.l10n.latestPromotions),
              SizedBox(
                height: 62.5,
              ),
              Text(
                context.l10n.downloadAppEnjoyBenefits,
                style: GoogleFonts.publicSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff0C0C0C)),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          minimumSize: Size.zero, padding: EdgeInsets.zero),
                      child: (language == LanguageMode.en)
                          ? Image.asset(kAppStoreBadgeEn,
                              width: 130, fit: BoxFit.contain)
                          : Image.asset(kAppStoreBadgeSk,
                              width: 130, fit: BoxFit.contain),
                      onPressed: () {
                        launchUrlString(UrlStrings.appStore);
                      }),
                  SizedBox(
                    width: 12,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          minimumSize: Size.zero, padding: EdgeInsets.zero),
                      child: (language == LanguageMode.en)
                          ? Image.asset(kGooglePlayBadgeEn,
                              width: 168, fit: BoxFit.contain)
                          : Image.asset(kGooglePlayBadgeSk,
                              width: 146, fit: BoxFit.contain),
                      onPressed: () {
                        launchUrlString(UrlStrings.googlePlay);
                      }),
                ],
              )
            ],
          ))
    ]);
  }
}
