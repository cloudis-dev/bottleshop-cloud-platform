import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/home/data/models/open_hours_model.dart';
import 'package:delivery/src/features/home/presentation/providers/providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/data/res/constants.dart';
import '../../../../../core/data/services/shared_preferences_service.dart';
import '../../../../../core/presentation/providers/core_providers.dart';

class Footer extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(currentLanguageProvider);
    final openHours = ref.watch(openHoursStreamProvider);
    return Container(
      height: 342,
      color: Colors.black,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                kLogoTransparent,
                height: 80,
                width: 80,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  "Bottleshop 3 veže",
                  style: GoogleFonts.publicSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: Text(
                    context.l10n.footerDescription,
                    style: publicSansTextTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(64, 100, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(context.l10n.contactColumn,
                    style: publicSansTextTheme.displayMedium),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text("Bottleroom s.r.o.",
                    style: publicSansTextTheme.bodySmall),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text("Bajkalská 9/A,",
                    style: publicSansTextTheme.bodySmall),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text("831 04 Bratislava",
                    style: publicSansTextTheme.bodySmall),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 26, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.mail,
                      color: Colors.white,
                      size: 14,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                      child: TextButton(
                        child: Text("info@bottleshop3veze.sk",
                            style: publicSansTextTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.underline)),
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
                    const Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 14,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
                      child: Text("+421 904 797 094",
                          style: publicSansTextTheme.bodySmall),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        openHours.when(error: (error, stackTrace) => Text(error.toString()), loading: () => CircularProgressIndicator(),
        data: (data) { 
          final workdays = data.firstWhere((element) => element.type == 'Workdays');
          final saturday = data.firstWhere((element) => element.type == 'Saturday');
          final sunday = data.firstWhere((element) => element.type == 'Sunday');
          return Container(
          padding: const EdgeInsets.fromLTRB(64, 100, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(context.l10n.openingHours,
                    style: publicSansTextTheme.displayMedium),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: workdays.isClosed ?
              Text("${context.l10n.monFr} ${context.l10n.closed}",
                    style: publicSansTextTheme.bodySmall):
              
              Text("${context.l10n.monFr} ${DateFormat.Hm().format(workdays.dateFrom).toString()} - ${DateFormat.Hm().format(workdays.dateTo).toString()}",
                    style: publicSansTextTheme.bodySmall),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              //   child: Text("${context.l10n.fri} 10:00 - 22:00",
              //       style: publicSansTextTheme.bodySmall),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: saturday.isClosed ?
              Text("${context.l10n.sat} ${context.l10n.closed}",
                    style: publicSansTextTheme.bodySmall):
              
              Text("${context.l10n.sat} ${DateFormat.Hm().format(saturday.dateFrom).toString()} - ${DateFormat.Hm().format(saturday.dateFrom).toString()}",
                    style: publicSansTextTheme.bodySmall),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: sunday.isClosed ?
              Text("${context.l10n.sun} ${context.l10n.closed}",
                    style: publicSansTextTheme.bodySmall):
              
              Text("${context.l10n.sun} ${DateFormat.Hm().format(sunday.dateFrom).toString()} - ${DateFormat.Hm().format(sunday.dateTo).toString()}",
                    style: publicSansTextTheme.bodySmall),
              ),              
            ],
          ),
        );}),
        Container(
          padding: const EdgeInsets.fromLTRB(64, 100, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: Text(context.l10n.informationColumn,
                    style: publicSansTextTheme.displayMedium),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .watch(navigationProvider)
                      .setNestingBranch(context, NestingBranch.help);
                },
                child: Text("F.A.Q.", style: publicSansTextTheme.bodySmall),
              ),
              BilingualLink(
                  txt: context.l10n.menuTerms,
                  enLink: UrlStrings.menuTermsEN,
                  skLink: UrlStrings.menuTermsSK),
              BilingualLink(
                  txt: context.l10n.privacyPolicy,
                  enLink: UrlStrings.privacyPolicyEN,
                  skLink: UrlStrings.privacyPolicySK),
              BilingualLink(
                  txt: context.l10n.shippingPayment,
                  enLink: UrlStrings.shippingPaymentEN,
                  skLink: UrlStrings.shippingPaymentSK),
              BilingualLink(
                  txt: context.l10n.wholesale,
                  enLink: UrlStrings.wholesaleEN,
                  skLink: UrlStrings.wholesaleSK),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(64, 100, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(context.l10n.findUs,
                    style: publicSansTextTheme.displayMedium),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: [
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
                            padding: const EdgeInsets.fromLTRB(21, 0, 0, 0)),
                        child: Image.asset(
                          kFacebookIcon,
                          height: 24,
                          width: 24,
                        ),
                        onPressed: () {
                          launchUrlString(UrlStrings.facebook);
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 12),
                child: Text(context.l10n.downloadApp,
                    style: publicSansTextTheme.displayMedium),
              ),
              TextButton(
                  style: TextButton.styleFrom(
                      minimumSize: Size.zero, padding: EdgeInsets.zero),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: (language == LanguageMode.en)
                        ? Image.asset(kAppStoreBadgeEn,
                            width: 93, fit: BoxFit.contain)
                        : Image.asset(kAppStoreBadgeSk,
                            width: 93, fit: BoxFit.contain),
                  ),
                  onPressed: () {
                    launchUrlString(UrlStrings.appStore);
                  }),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: TextButton(
                    style: TextButton.styleFrom(
                        minimumSize: Size.zero, padding: EdgeInsets.zero),
                    child: (language == LanguageMode.en)
                        ? Image.asset(kGooglePlayBadgeEn,
                            width: 107, fit: BoxFit.contain)
                        : Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Image.asset(kGooglePlayBadgeSk,
                                width: 93, fit: BoxFit.contain)),
                    onPressed: () {
                      launchUrlString(UrlStrings.googlePlay);
                    }),
              )
            ],
          ),
        )
      ]),
    );
  }
}
