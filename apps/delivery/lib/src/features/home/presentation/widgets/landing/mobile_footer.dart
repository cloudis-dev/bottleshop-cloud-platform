import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/data/res/constants.dart';
import '../../../../../core/data/services/shared_preferences_service.dart';
import '../../../../../core/presentation/providers/core_providers.dart';

class MobileFooter extends HookConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(currentLanguageProvider);

    return Container(
      padding: EdgeInsets.only(left: 65, top: 80, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            kLogoTransparent,
            height: 100,
            width: 100,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Bottleshop 3 veže",
            style: GoogleFonts.publicSans(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 350,
            child: Text(
              context.l10n.footerDescription,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(context.l10n.contactColumn,
                style: publicSansTextTheme.headline2),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child:
                Text("Bottleroom s.r.o.", style: publicSansTextTheme.caption),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text("Bajkalská 9/A,", style: publicSansTextTheme.caption),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child:
                Text("831 04 Bratislava", style: publicSansTextTheme.caption),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.mail,
                  color: Colors.white,
                  size: 14,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                  child: TextButton(
                    child: Text("info@bottleshop3veze.sk",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(decoration: TextDecoration.underline)),
                    onPressed: () {
                      launchUrlString("mailto:info@bottleshop3veze.sk");
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone,
                  color: Colors.white,
                  size: 14,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
                  child: Text("+421 904 797 094",
                      style: publicSansTextTheme.caption),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(context.l10n.openingHours,
                style: publicSansTextTheme.headline2),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(context.l10n.monTh + " 10:00 - 22:00",
                style: publicSansTextTheme.caption),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(context.l10n.fri + " 10:00 - 24:00",
                style: publicSansTextTheme.caption),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(context.l10n.sat + " 12:00 - 24:00",
                style: publicSansTextTheme.caption),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(context.l10n.sun + context.l10n.closed,
                style: publicSansTextTheme.caption),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(context.l10n.informationColumn,
                style: publicSansTextTheme.headline2),
          ),
          Transform.translate(
            // e.g: vertical negative margin
            offset: const Offset(-8, 0),
            child: TextButton(
              onPressed: () {
                ref
                    .watch(navigationProvider)
                    .setNestingBranch(context, NestingBranch.help);
              },
              child: Text("F.A.Q.", style: publicSansTextTheme.caption),
            ),
          ),
          Transform.translate(
            // e.g: vertical negative margin
            offset: const Offset(-8, 0),
            child: BilingualLink(
                txt: context.l10n.menuTerms,
                enLink: UrlStrings.menuTermsEN,
                skLink: UrlStrings.menuTermsSK),
          ),
          Transform.translate(
            // e.g: vertical negative margin
            offset: const Offset(-8, 0),
            child: BilingualLink(
                txt: context.l10n.privacyPolicy,
                enLink: UrlStrings.privacyPolicyEN,
                skLink: UrlStrings.privacyPolicySK),
          ),
          Transform.translate(
            // e.g: vertical negative margin
            offset: const Offset(-8, 0),
            child: BilingualLink(
                txt: context.l10n.shippingPayment,
                enLink: UrlStrings.shippingPaymentEN,
                skLink: UrlStrings.shippingPaymentSK),
          ),
          Transform.translate(
            // e.g: vertical negative margin
            offset: const Offset(-8, 0),
            child: BilingualLink(
                txt: context.l10n.wholesale,
                enLink: UrlStrings.wholesaleEN,
                skLink: UrlStrings.wholesaleSK),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child:
                Text(context.l10n.findUs, style: publicSansTextTheme.headline2),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(children: [
                TextButton(
                    style: TextButton.styleFrom(
                        minimumSize: Size.zero, padding: EdgeInsets.zero),
                    child: Image.asset(
                      kInsagramIcon,
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () {
                      launchUrlString(UrlStrings.instagram);
                    }),
                TextButton(
                    style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.fromLTRB(21, 0, 0, 0)),
                    child: Image.asset(
                      kFacebookIcon,
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () {
                      launchUrlString(UrlStrings.facebook);
                    }),
              ])),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 12),
            child: Text(context.l10n.downloadApp,
                style: publicSansTextTheme.headline2),
          ),
          Transform.translate(
            // e.g: vertical negative margin
            offset: const Offset(-8, 0),
            child: TextButton(
                style: TextButton.styleFrom(
                    minimumSize: Size.zero, padding: EdgeInsets.zero),
                child: Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: (language == LanguageMode.en)
                      ? Image.asset(kAppStoreBadgeEn,
                          width: 93, fit: BoxFit.contain)
                      : Image.asset(kAppStoreBadgeSk,
                          width: 93, fit: BoxFit.contain),
                ),
                onPressed: () {
                  launchUrlString(UrlStrings.appStore);
                }),
          ),
          Transform.translate(
            // e.g: vertical negative margin
            offset: const Offset(-8, 0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: TextButton(
                  style: TextButton.styleFrom(
                      minimumSize: Size.zero, padding: EdgeInsets.zero),
                  child: (language == LanguageMode.en)
                      ? Image.asset(kGooglePlayBadgeEn,
                          width: 107, fit: BoxFit.contain)
                      : Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Image.asset(kGooglePlayBadgeSk,
                              width: 93, fit: BoxFit.contain)),
                  onPressed: () {
                    launchUrlString(UrlStrings.googlePlay);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
