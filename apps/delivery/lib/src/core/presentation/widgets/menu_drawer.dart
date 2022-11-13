// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'package:badges/badges.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/bottleshop_badge.dart';
import 'package:delivery/src/core/presentation/widgets/side_menu_header.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/terms_conditions_view.dart';
import 'package:delivery/src/features/opening_hours/presentation/dialogs/opening_hours_dialog.dart';
import 'package:delivery/src/features/opening_hours/presentation/widgets/opening_hours_calendar.dart';
import 'package:delivery/src/features/orders/presentation/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:routeborn/routeborn.dart';

final _versionProvider = FutureProvider.autoDispose<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

class MenuDrawer extends HookWidget {
  @literal
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final orderBadge = useProvider(activeOrdersCountProvider)
            .whenData((value) => value)
            .data
            ?.value ??
        0;

    final hasUser =
        useProvider(currentUserProvider.select((value) => value != null));
    final currentBranch = useProvider(
        navigationProvider.select((value) => value.getNestingBranch(context)));

    return Drawer(
      child: CupertinoScrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: IconTheme.of(context).copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: <Widget>[
              if (hasUser) const SideMenuHeader(),
              _SideMenuItem(
                isSelected:
                    kIsWeb ? currentBranch == NestingBranch.shop : false,
                leading: Icons.home,
                title: context.l10n.homeTabLabel,
                handler: () {
                  final nav = context.read(navigationProvider);

                  if (nav.getNestingBranch(context) == NestingBranch.shop) {
                    nav.replaceAllWith(context, []);
                  } else {
                    nav.setNestingBranch(context, NestingBranch.shop);
                  }
                },
              ),
              _SideMenuItem(
                isSelected:
                    kIsWeb ? currentBranch == NestingBranch.categories : false,
                leading: Icons.liquor,
                title: context.l10n.categories,
                handler: () {
                  final nav = context.read(navigationProvider);

                  if (nav.getNestingBranch(context) ==
                      NestingBranch.categories) {
                    nav.replaceAllWith(context, []);
                  } else {
                    nav.setNestingBranch(
                      context,
                      NestingBranch.categories,
                    );
                  }
                },
              ),
              _SideMenuItem(
                isSelected:
                    kIsWeb ? currentBranch == NestingBranch.favorites : false,
                leading: Icons.favorite,
                title: context.l10n.favoriteTabLabel,
                handler: () {
                  final nav = context.read(navigationProvider);

                  if (nav.getNestingBranch(context) ==
                      NestingBranch.favorites) {
                    nav.replaceAllWith(context, []);
                  } else {
                    nav.setNestingBranch(
                      context,
                      NestingBranch.favorites,
                    );
                  }
                },
              ),
              if (hasUser)
                _SideMenuItem(
                  isSelected:
                      kIsWeb ? currentBranch == NestingBranch.cart : false,
                  leading: Icons.shopping_cart,
                  title: context.l10n.shopping_cart,
                  handler: () {
                    context.read(navigationProvider).setNestingBranch(
                          context,
                          NestingBranch.cart,
                        );
                  },
                ),
              _SideMenuItem(
                isSelected:
                    kIsWeb ? currentBranch == NestingBranch.orders : false,
                leading: Icons.fact_check_outlined,
                handler: () {
                  final nav = context.read(navigationProvider);

                  if (nav.getNestingBranch(context) == NestingBranch.orders) {
                    nav.replaceAllWith(context, []);
                  } else {
                    nav.setNestingBranch(
                      context,
                      NestingBranch.orders,
                      branchParam: nav.getNestingBranch(context),
                    );
                  }
                },
                title: context.l10n.orderTabLabel,
                badgeValue: orderBadge,
              ),
              _SideMenuItem(
                isSelected:
                    kIsWeb ? currentBranch == NestingBranch.wholesale : false,
                leading: Icons.store,
                title: context.l10n.wholesale,
                handler: () {
                  final nav = context.read(navigationProvider);

                  if (nav.getNestingBranch(context) ==
                      NestingBranch.wholesale) {
                    nav.replaceAllWith(context, []);
                  } else {
                    nav.setNestingBranch(
                      context,
                      NestingBranch.wholesale,
                      branchParam: nav.getNestingBranch(context),
                    );
                  }
                },
              ),
              _SideMenuItem(
                dense: true,
                title: context.l10n.applicationPreferences,
                titleStyle: Theme.of(context).textTheme.overline,
              ),
              _SideMenuItem(
                isSelected:
                    kIsWeb ? currentBranch == NestingBranch.account : false,
                leading: Icons.settings,
                title: context.l10n.settings,
                handler: () {
                  final nav = context.read(navigationProvider);

                  if (nav.getNestingBranch(context) == NestingBranch.account) {
                    nav.replaceAllWith(context, []);
                  } else {
                    nav.setNestingBranch(
                      context,
                      NestingBranch.account,
                      branchParam: nav.getNestingBranch(context),
                    );
                  }
                },
              ),
              _SideMenuItem(
                isSelected:
                    kIsWeb ? currentBranch == NestingBranch.help : false,
                leading: Icons.help_outlined,
                title: context.l10n.helpSupport,
                handler: () {
                  final nav = context.read(navigationProvider);

                  if (nav.getNestingBranch(context) == NestingBranch.help) {
                    nav.replaceAllWith(context, []);
                  } else {
                    nav.setNestingBranch(
                      context,
                      NestingBranch.help,
                      branchParam: nav.getNestingBranch(context),
                    );
                  }
                },
              ),
              const BottleshopAboutTile(),
              _SideMenuItem(
                leading: Icons.gavel,
                handler: () {
                  context.read(navigationProvider).pushPage(
                        context,
                        AppPageNode(page: TermsConditionsPage()),
                        toParent: true,
                      );
                },
                title: context.l10n.menuTerms,
              ),
              if (hasUser)
                _SideMenuItem(
                  handler: () async {
                    await context.read(userRepositoryProvider).signOut();
                  },
                  leading: Icons.exit_to_app,
                  title: context.l10n.logOut,
                ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const OpeningHoursCalendar(),
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => const OpeningHoursDialog(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideMenuItem extends StatelessWidget {
  final IconData? leading;
  final String? title;
  final TextStyle? titleStyle;
  final VoidCallback? handler;
  final Widget? trailing;
  final bool dense;
  final int badgeValue;
  final bool isSelected;

  const _SideMenuItem({
    Key? key,
    this.leading,
    this.title,
    this.titleStyle,
    this.trailing,
    this.handler,
    this.dense = false,
    this.badgeValue = 0,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedTileColor: Theme.of(context).focusColor,
      selected: isSelected,
      dense: dense,
      enabled: handler != null,
      onTap: handler != null
          ? () {
              context.findAncestorStateOfType<DrawerControllerState>()!.close();
              handler!.call();
            }
          : null,
      leading: leading != null ? _buildBadgeIcon(context) : null,
      title: Text(
        title!,
        style: titleStyle ?? Theme.of(context).textTheme.subtitle2,
      ),
      trailing: trailing,
    );
  }

  Widget _buildBadgeIcon(BuildContext context) {
    return BottleshopBadge(
      badgeText: badgeValue.toString(),
      showBadge: badgeValue > 0,
      position: BadgePosition.topEnd(top: -5, end: -5),
      child: Icon(
        leading,
        color: IconTheme.of(context).color,
      ),
    );
  }
}

class BottleshopAboutTile extends HookWidget {
  final VoidCallback? afterTap;

  const BottleshopAboutTile({Key? key, this.afterTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final version = useProvider(_versionProvider);

    return ListTile(
      dense: false,
      leading: Icon(
        Icons.info,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(context.l10n.aboutUs),
      onTap: () {
        showAboutDialog(
          context: context,
          applicationIcon: Container(
            height: 64,
            width: 64,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(kAppIcon),
              ),
            ),
          ),
          applicationName: context.l10n.app_title,
          applicationVersion: version.maybeWhen(
            data: (version) => '${version.version}.${version.buildNumber}',
            orElse: () => null,
          ),
          applicationLegalese: context.l10n.companyAndYear,
        );

        afterTap?.call();
      },
    );
  }
}
