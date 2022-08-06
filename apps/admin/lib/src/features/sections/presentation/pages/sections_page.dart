import 'package:bottleshop_admin/src/core/presentation/widgets/app_navigation_drawer.dart';
import 'package:bottleshop_admin/src/features/section_flash_sales/presentation/pages/flash_sale_view.dart';
import 'package:bottleshop_admin/src/features/section_new_entries/presentation/pages/new_entries_view.dart';
import 'package:bottleshop_admin/src/features/section_recommended/presentation/pages/recommended_view.dart';
import 'package:bottleshop_admin/src/features/section_sale/presentation/widgets/sale_view.dart';
import 'package:flutter/material.dart';

class SectionsPage extends StatelessWidget {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  const SectionsPage({Key? key}) : super(key: key);

  static const List<String> navigationTabsNames = [
    'FLASH SALE',
    'VÝPREDAJ',
    'NOVINKY',
    'ODPORÚČANÉ',
  ];

  static final List<Widget> navigationTabs = navigationTabsNames
      .map(
        (name) => ConstrainedBox(
          constraints: BoxConstraints(minWidth: 90),
          child: Tab(text: name),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) => ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: DefaultTabController(
          length: navigationTabsNames.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Sekcie'),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(48),
                child: TabBar(
                  isScrollable: true,
                  tabs: navigationTabs,
                ),
              ),
            ),
            drawer: const AppNavigationDrawer(),
            body: TabBarView(
              children: <Widget>[
                const FlashSaleView(),
                const SaleView(),
                const NewEntriesView(),
                const RecommendedView(),
              ],
            ),
          ),
        ),
      );
}
