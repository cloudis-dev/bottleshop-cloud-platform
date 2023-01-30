import 'package:badges/badges.dart';
import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/bottleshop_badge.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_popup_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/molecules/cart_icon_with_badge.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/language_dropdown.dart';
import 'package:delivery/src/features/orders/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../core/data/res/constants.dart';

class MobileHeader extends HookConsumerWidget {
  final Widget? filterBtn;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const MobileHeader({super.key, required this.scaffoldKey, this.filterBtn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(navigationProvider);
    final showBadge = ref
            .watch(activeOrdersCountProvider)
            .whenData((value) => value > 0)
            .value ??
        false;

    return Container(
        color: Colors.black,
        height: 90,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  IconButton(
                    color: kPrimaryColor,
                    icon: BottleshopBadge(
                      position: BadgePosition.topEnd(top: 0, end: 0),
                      showBadge: showBadge,
                      badgeText: null,
                      child: const Icon(Icons.menu),
                    ),
                    iconSize: 25,
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    icon: Image.asset(kLogoTransparent),
                    iconSize: 45,
                    onPressed: () {
                      navigation.setNestingBranch(
                          context, NestingBranch.landing);
                    },
                  ),
                ],
              ),
              Row(children: [
                const LanguageDropdown(),
                const SizedBox(
                  width: 5,
                ),
                filterBtn != null
                    ? Row(children: [
                        filterBtn!,
                        const SizedBox(
                          width: 5,
                        ),
                      ])
                    : Container(),
                IconButton(
                  onPressed: () {
                    navigation.setNestingBranch(context, NestingBranch.search);
                  },
                  color: kPrimaryColor,
                  icon: const Icon(
                    Icons.search,
                  ),
                  iconSize: 25,
                ),
                const SizedBox(
                  width: 5,
                ),
                IconButton(
                  onPressed: () {
                    navigation.setNestingBranch(context, NestingBranch.cart);
                  },
                  color: kPrimaryColor,
                  icon: const CartIconWithBadge(),
                  iconSize: 25,
                ),
                const SizedBox(
                  width: 5,
                ),
                AuthPopupButton(
                  scaffoldKey: scaffoldKey,
                ),
                const SizedBox(
                  width: 15,
                ),
              ]),
            ]));
  }
}
