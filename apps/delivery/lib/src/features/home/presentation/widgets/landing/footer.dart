import 'package:delivery/src/features/home/presentation/widgets/landing/buttons.dart';
import 'package:flutter/material.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:flutter/material.dart';

import '../../../../../core/data/res/constants.dart';


class Footer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      height: 342,
      color: Colors.black,
      child: Row(children: [
        Container(
          padding: EdgeInsets.fromLTRB(175, 100, 0, 0),
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
                child: Container(
                  constraints: BoxConstraints(maxWidth: 250),
                  child: Text(
                    context.l10n.footerDescription,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(64, 100, 0, 0),
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
                child: Text("Bottleroom s.r.o.",
                    style: Theme.of(context).textTheme.headline5),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text("Bajkalská 9/A,",
                    style: Theme.of(context).textTheme.headline5),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text("831 04 Bratislava",
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
          padding: EdgeInsets.fromLTRB(64, 100, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(context.l10n.openingHours,
                    style: Theme.of(context).textTheme.headline2),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(context.l10n.monTh+" 10:00 - 22:00",
                    style: Theme.of(context).textTheme.headline5),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(context.l10n.fri+" 10:00 - 24:00",
                    style: Theme.of(context).textTheme.headline5),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(context.l10n.sat+" 12:00 - 24:00",
                    style: Theme.of(context).textTheme.headline5),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(context.l10n.sun+context.l10n.closed,
                    style: Theme.of(context).textTheme.headline5),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(64, 100, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: Text(context.l10n.informationColumn,
                    style: Theme.of(context).textTheme.headline2),
              ),
              Link(txt: "F.A.Q."),
              Link(txt: context.l10n.menuTerms),
              Link(txt: context.l10n.privacyPolicy),
              Link(txt: context.l10n.shippingPayment),
              Link(txt: context.l10n.wholesale),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(64, 100, 0, 0),
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
                    TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero
                        ),
                        child: Image.asset(
                          kInsagramIcon,
                          height: 24,
                          width: 24,
                        ),
                        onPressed: () {}),
                    TextButton(
                      style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.fromLTRB(21, 0, 0, 0)
                        ),
                        child: Image.asset(
                          kFacebookIcon,
                          height: 24,
                          width: 24,
                        ),
                        onPressed: () {}),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 12),
                child: Text(context.l10n.downloadApp,
                    style: Theme.of(context).textTheme.headline2),
              ),
              TextButton(
                 style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero
                        ),
                  child: Image.asset(
                    kAppStoreDownload,
                    height: 33,
                    width: 97,
                  ),
                  onPressed: () {}),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: TextButton(
                   style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero
                        ),
                    child: Image.asset(
                      kGooglePlayDownload,
                      height: 33,
                      width: 107,
                    ),
                    onPressed: () {}),
              )
            ],
          ),
        )
      ]),
    );
  }
}
