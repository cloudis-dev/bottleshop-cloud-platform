import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/adaptive_bottom_navigation_scaffold.dart';
import 'package:delivery/src/core/presentation/widgets/bottom_navigation_tab.dart';
import 'package:delivery/src/features/home/presentation/widgets/cart_icon_with_badge.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeMobileScaffold extends HookConsumerWidget {
  const HomeMobileScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveBottomNavigationScaffold(
      navigationBarItems: [
        BottomNavigationTab(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: context.l10n.homeTabLabel,
          ),
        ),
        BottomNavigationTab(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: const Icon(Icons.liquor),
            label: context.l10n.categories,
          ),
        ),
        BottomNavigationTab(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: context.l10n.favoriteTabLabel,
          ),

          // navigatorKey: favoriteTabKey,
          // scaffoldKey: favoriteScaffoldKey,
          // initialPageBuilder: (context) => const FavoritesTab(),
        ),
        BottomNavigationTab(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: const CartIconWithBadge(),
            label: context.l10n.shopping_cart,
          ),
        ),
      ],
    );
  }
}
