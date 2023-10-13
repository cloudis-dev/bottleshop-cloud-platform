import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/app_page.dart';
import 'package:bottleshop_admin/src/features/home/presentation/pages/home_view.dart';
import 'package:bottleshop_admin/src/features/orders/data/models/order_model.dart';
import 'package:bottleshop_admin/src/features/orders/presentation/pages/orders_page.dart';
import 'package:bottleshop_admin/src/features/orders/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/products/presentation/pages/products_page.dart';
import 'package:bottleshop_admin/src/features/products/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/pages/promo_codes_view.dart';
import 'package:bottleshop_admin/src/features/sections/presentation/pages/sections_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../open_hours/presentation/open_hours_view.dart';

enum TabIndex {
  home,
  orders,
  products,
  sections,
  promoCodes,
  openHours
}

final appActivityTabIndexProvider =
    StateProvider.autoDispose<TabIndex>((_) => TabIndex.home);

class AppActivityPage extends AppPage {
  AppActivityPage({
    required TabIndex initialIndex,
  }) : super(
          'app',
          (_) => _AppActivity(initialIndex),
          pageArgs: initialIndex,
        );
}

class _AppActivity extends HookWidget {
  _AppActivity(this._initialIndex);

  final TabIndex _initialIndex;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.microtask(
        () {
          context.read(appActivityTabIndexProvider).state = _initialIndex;
        },
      );
      return;
    }, []);

    // This is to preserve state until user signs-out
    useProvider(ordersStateProvider(OrderStep.ordered));
    useProvider(ordersStateProvider(OrderStep.ready));
    useProvider(ordersStateProvider(OrderStep.shipped));
    useProvider(ordersStateProvider(OrderStep.completed));

    useProvider(productsStateProvider);

    return const ScaffoldMessenger(
      child: Scaffold(
        body: _BodyWidget(),
        bottomNavigationBar: _BottomNavigationBar(),
      ),
    );
  }
}

class _BottomNavigationBar extends HookWidget {
  const _BottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        backgroundColor: AppTheme.primaryColor,
        currentIndex: useProvider(appActivityTabIndexProvider).state.index,
        onTap: (i) => context.read(appActivityTabIndexProvider).state =
            TabIndex.values[i],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Domov',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Objednávky',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Produkty',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_stream),
            label: 'Sekcie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Kupóny',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse),
            label: 'Rozvrh',
          )
        ],
      );
}

class _BodyWidget extends HookWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabIndex = useProvider(appActivityTabIndexProvider).state;

    switch (tabIndex) {
      case TabIndex.home:
        return const HomeView();
      case TabIndex.orders:
        return const OrdersPage();
      case TabIndex.products:
        return ProductsPage();
      case TabIndex.sections:
        return const SectionsPage();
      case TabIndex.promoCodes:
        return const PromoCodesView();
        case TabIndex.openHours:
        return const OpenHoursView();
    }
  }
}
