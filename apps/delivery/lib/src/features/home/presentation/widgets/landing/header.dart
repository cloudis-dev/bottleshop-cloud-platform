import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/buttons.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/language_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/data/res/constants.dart';

class Header extends HookConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(navigationProvider);
    final currentUser = ref.watch(currentUserProvider);
    return Container(
      height: 118,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(160, 35, 0, 35),
            child: Row(
              children: [
                IconButton(
                  icon: Image.asset(kLogoTransparent),
                  iconSize: 50,
                  onPressed: () {
                    navigation.setNestingBranch(context, NestingBranch.landing);
                  },
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    children: [
                      Btns(
                        txt: context.l10n.homeButton,
                        nestingBranch: NestingBranch.landing,
                      ),
                      Btns(
                        txt: "ESHOP",
                        nestingBranch: NestingBranch.shop,
                      ),
                      Btns(
                        txt: context.l10n.saleButton,
                        nestingBranch: NestingBranch.sale,
                      ),
                      Btns(
                        txt: context.l10n.contactButton,
                        nestingBranch: NestingBranch.help,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 160),
            child: Row(children: [
              const LanguageDropdown(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: IconButton(
                  onPressed: () {
                    navigation.setNestingBranch(context, NestingBranch.search);
                  },
                  color: kPrimaryColor,
                  icon: Icon(
                    Icons.search,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: IconButton(
                  onPressed: () {
                    navigation.setNestingBranch(context, NestingBranch.cart);
                  },
                  color: kPrimaryColor,
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: IconButton(
                  onPressed: () {
                    navigation.setNestingBranch(context, NestingBranch.account);
                  },
                  color: kPrimaryColor,
                  icon: Icon(
                    Icons.person,
                  ),
                ),
              ),
              if (currentUser != null)
                Text(
                  currentUser.name.toString(),
                  style: publicSansTextTheme.overline,
                ),
            ]),
          ),
        ],
      ),
    );
  }
}
