import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_popup_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/buttons.dart';
import 'package:delivery/src/features/home/presentation/widgets/molecules/cart_icon_with_badge.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/language_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../core/data/res/constants.dart';

class Header extends HookConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget? filterBtn;
  const Header({Key? key, required this.scaffoldKey, this.filterBtn})
      : super(key: key);

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
            margin: const EdgeInsets.fromLTRB(100, 35, 0, 35),
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
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    children: [
                      Btns(
                        txt: context.l10n.homeButton,
                        nestingBranch: NestingBranch.landing,
                      ),
                      const Btns(
                        txt: "ESHOP",
                        nestingBranch: NestingBranch.shop,
                      ),
                      Btns(
                        txt: context.l10n.categoriesButton,
                        nestingBranch: NestingBranch.categories,
                      ),
                      BtnWithActiveOrdersBadge(
                        txt: context.l10n.ordersButton,
                        nestingBranch: NestingBranch.orders,
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
            margin: EdgeInsets.only(right: 100),
            child: Row(children: [
              const LanguageDropdown(),
              filterBtn != null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: filterBtn)
                  : Container(),
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
                      navigation.setNestingBranch(
                        context,
                        NestingBranch.cart,
                        resetBranchStack: true,
                      );
                    },
                    color: kPrimaryColor,
                    icon: const CartIconWithBadge()),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: AuthPopupButton(
                    scaffoldKey: scaffoldKey,
                  )),
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
