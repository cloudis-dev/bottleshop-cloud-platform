import 'package:badges/badges.dart';
import 'package:delivery/src/core/presentation/widgets/bottleshop_badge.dart';
import 'package:delivery/src/features/orders/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MenuButton extends HookConsumerWidget {
  final GlobalKey<ScaffoldState> drawerScaffoldKey;

  const MenuButton({Key? key, required this.drawerScaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBadge = ref
            .watch(activeOrdersCountProvider)
            .whenData((value) => value > 0)
            .value ??
        false;

    return IconButton(
      icon: BottleshopBadge(
        position: BadgePosition.topEnd(top: 0, end: 0),
        showBadge: showBadge,
        badgeText: null,
        child: const Icon(Icons.menu),
      ),
      onPressed: () {
        drawerScaffoldKey.currentState!.openDrawer();
      },
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
    );
  }
}
