import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/drawer_state_acquirer.dart';
import 'package:delivery/src/core/presentation/widgets/menu_drawer.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_popup_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/menu_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/cart_appbar_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/filter_icon_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/language_dropdown.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/search_icon_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/home_page_template.dart';
import 'package:delivery/src/features/home/presentation/widgets/views/home_products_body.dart';
import 'package:delivery/src/features/product_sections/presentation/providers/providers.dart';
import 'package:delivery/src/features/products/presentation/providers/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:routeborn/routeborn.dart';

import '../../../../core/data/res/constants.dart';

class Btns extends StatelessWidget {
  final String txt;
  const Btns({Key? key, required this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
      child: TextButton(
        onPressed: () {},
        child: Text(
          txt,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }
}

class Link extends StatelessWidget {
  final String txt;
  const Link({Key? key, required this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextButton(
        onPressed: () {},
        child: Text(txt, style: Theme.of(context).textTheme.headline5),
      ),
    );
  }
}

class Header extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      color: Colors.black,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(160, 35, 0, 35),
            child: Row(
              children: [
                IconButton(
                  icon: Image.asset(kLogoTransparent),
                  iconSize: 50,
                  onPressed: () {},
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    children: [
                      Btns(txt: context.l10n.homeButton),
                      Btns(txt: "ESHOP"),
                      Btns(txt: context.l10n.specOfferButton),
                      Btns(txt: context.l10n.aboutUsButton),
                      Btns(txt: context.l10n.contactButton),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(335, 0, 0, 0),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: IconButton(
                  onPressed: () {},
                  color: Color(0xFFBF8A24),
                  icon: Icon(
                    Icons.search,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: IconButton(
                  onPressed: () {},
                  color: Color(0xFFBF8A24),
                  icon: Icon(
                    Icons.person,
                  ),
                ),
              ),
              Text("User", style: Theme.of(context).textTheme.headline4),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: IconButton(
                  onPressed: () {},
                  color: Color(0xFFBF8A24),
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      height: 342,
      color: Colors.black,
      child: Row(children: [
        Container(
          padding: EdgeInsets.fromLTRB(165, 100, 0, 0),
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
                  "Bottleshop 3 veze",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  context.l10n.footerDescription,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(100, 100, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(context.l10n.contactColumn,
                    style: Theme.of(context).textTheme.headline2),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                    "Bottleroom s.r.o.",
                    style: Theme.of(context).textTheme.headline5),
              ),
               Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                    "Bajkalská 9/A,",
                    style: Theme.of(context).textTheme.headline5),
              ),
               Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                    "831 04 Bratislava",
                    style: Theme.of(context).textTheme.headline5),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 26, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mail,
                      color: Colors.white,
                      size: 14,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
                      child: Text("info@bottleshop3veze.sk",
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(decoration: TextDecoration.underline)),
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
                          style: Theme.of(context).textTheme.headline5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(100, 100, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: Text(context.l10n.informationColumn,
                    style: Theme.of(context).textTheme.headline2),
              ),
              Link(txt: context.l10n.faq),
              Link(txt: context.l10n.menuTerms),
              Link(txt: context.l10n.privacyPolicy),
              Link(txt: context.l10n.shippingPayment),
              Link(txt: context.l10n.wholesale),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(115, 100, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(context.l10n.findUs,
                    style: Theme.of(context).textTheme.headline2),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: [
                      Container(
                        width: 35,
                        child: TextButton(
                          
                            child: Image.asset(
                              kFacebookIcon,
                              height: 24,
                              width: 24,
                            ),
                            onPressed: () {}),
                      ),
                    Container(
                      margin: EdgeInsets.only(left: 6),
                      width: 35,
                      child: TextButton(
                          child: Image.asset(
                            kInsagramIcon,
                            height: 24,
                            width: 24,
                          ),
                          onPressed: () {}),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 8),
                child: Text(context.l10n.downloadApp,
                    style: Theme.of(context).textTheme.headline2),
              ),
              TextButton(
                  child: Image.asset(
                    kAppStoreDownload,
                    height: 38,
                    width: 117,
                  ),
                  onPressed: () {})
            ],
          ),
        )
      ]),
    );
  }
}

class Landing extends StatelessWidget {
  const Landing({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Header(),
        Footer(),
      ],
    ));
  }
}
