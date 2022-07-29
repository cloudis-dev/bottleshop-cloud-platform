import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:bottleshop_admin/constants/bottleshop_icons.dart';
import 'package:bottleshop_admin/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/features/orders/presentation/pages/orders_summary_page.dart';
import 'package:bottleshop_admin/orders_step.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/tabs_views/orders_view/widgets/orders_list.dart';
import 'package:bottleshop_admin/ui/shared_widgets/app_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum _ContextMenuActions { summary }

class OrdersView extends StatelessWidget {
  static const String routeName = '/orders';

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  const OrdersView({Key? key}) : super(key: key);

  static const List<IconData> orderStepsIcons = [
    Bottleshop.circledOne,
    Bottleshop.circledTwo,
    Bottleshop.circledThree,
    Bottleshop.checkCircleOutline24px
  ];

  static const List<String> orderStepsNames = [
    'Objednané',
    'Pripravené',
    'Na ceste',
    'Vybavené'
  ];

  static final List<Widget> navigationTabs =
      Iterable<int>.generate(orderStepsIcons.length)
          .map(
            (id) => ConstrainedBox(
              constraints: BoxConstraints(minWidth: 90),
              child: Tab(
                  icon: Icon(orderStepsIcons[id], size: 24),
                  text: orderStepsNames[id].toUpperCase()),
            ),
          )
          .toList();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: DefaultTabController(
        length: navigationTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Objednávky'),
            actions: <Widget>[
              PopupMenuButton<_ContextMenuActions>(
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: _ContextMenuActions.summary,
                    child: Text(
                      'Denná sumarizácia',
                      style: AppTheme.popupMenuItemTextStyle,
                    ),
                  ),
                ],
                onSelected: (val) {
                  switch (val) {
                    case _ContextMenuActions.summary:
                      context
                          .read(navigationProvider.notifier)
                          .pushPage(OrdersSummaryPage());
                  }
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(72),
              child: TabBar(isScrollable: true, tabs: navigationTabs),
            ),
          ),
          drawer: const AppNavigationDrawer(),
          body: const TabBarView(
            children: <Widget>[
              OrdersList(orderStep: OrderStep.ordered),
              OrdersList(orderStep: OrderStep.ready),
              OrdersList(orderStep: OrderStep.shipped),
              OrdersList(orderStep: OrderStep.completed)
            ],
          ),
        ),
      ),
    );
  }
}
