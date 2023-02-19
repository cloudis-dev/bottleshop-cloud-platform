import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/language_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/data/res/constants.dart';

class MobileHeader extends HookConsumerWidget {
  const MobileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(navigationProvider);
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
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    color: kPrimaryColor,
                    icon: const Icon(
                      Icons.menu,
                    ),
                    iconSize: 25,
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
                    navigation.setNestingBranch(
                      context,
                      NestingBranch.cart,
                      resetBranchStack: true,
                    );
                  },
                  color: kPrimaryColor,
                  icon: const Icon(
                    Icons.shopping_cart,
                  ),
                  iconSize: 25,
                ),
                const SizedBox(
                  width: 5,
                ),
                IconButton(
                  onPressed: () {
                    navigation.setNestingBranch(context, NestingBranch.account);
                  },
                  color: kPrimaryColor,
                  icon: const Icon(
                    Icons.person,
                  ),
                  iconSize: 25,
                ),
                const SizedBox(
                  width: 15,
                ),
              ]),
            ]));
  }
}
