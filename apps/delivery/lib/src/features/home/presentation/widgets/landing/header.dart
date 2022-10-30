import 'package:delivery/src/features/home/presentation/widgets/landing/buttons.dart';
import 'package:flutter/material.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:flutter/material.dart';

import '../../../../../core/data/res/constants.dart';

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
                    Icons.shopping_cart,
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
            ]),
          ),
        ],
      ),
    );
  }
}
