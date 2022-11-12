import 'dart:html';

import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/products/presentation/pages/category_products_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:routeborn/routeborn.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Btns extends HookConsumerWidget {
  final String txt;
  final NestingBranch? nestingBranch;
  const Btns({Key? key, required this.txt, this.nestingBranch})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
      child: TextButton(
        onPressed: () {
          if (nestingBranch != null) {
            ref
                .watch(navigationProvider)
                .setNestingBranch(context, nestingBranch!);
          }
        },
        child: Text(
          txt,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }
}

class BilingualLink extends HookConsumerWidget {
  final String txt;
  final String enLink;
  final String skLink;
  const BilingualLink(
      {Key? key, required this.txt, required this.enLink, required this.skLink})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(
      sharedPreferencesProvider.select((value) => value.getAppLanguage()),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextButton(
        onPressed: () {
          if (language == LanguageMode.en) {
            launchUrlString(enLink);
          } else {
            launchUrlString(skLink);
          }
        },
        child: Text(txt, style: Theme.of(context).textTheme.headline5),
      ),
    );
  }
}

class LandingPageButton extends HookConsumerWidget {
  final String txt;
  final NestingBranch nestingBranch;
  RoutebornPage? routebornPage;

  LandingPageButton(
      {super.key,
      required this.txt,
      required this.nestingBranch,
      this.routebornPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Color.fromRGBO(191, 138, 36, 1)),
            bottom:
                BorderSide(width: 1.0, color: Color.fromRGBO(191, 138, 36, 1)),
          ),
        ),
        child: TextButton(
          onPressed: () {
            ref
                .read(navigationProvider)
                .setNestingBranch(context, nestingBranch);
            if (routebornPage != null) {
              ref.read(navigationProvider).pushPage(
                    context,
                    AppPageNode(page: routebornPage!),
                  );
            }
          },
          child: Padding(
              padding:
                  EdgeInsets.only(left: 16, top: 12, bottom: 12, right: 16),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    txt.toUpperCase(),
                    style: GoogleFonts.publicSans(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                Image.asset(
                  kBtnArrow,
                  width: 37,
                  fit: BoxFit.fitHeight,
                ),
              ])),
        ));
  }
}
