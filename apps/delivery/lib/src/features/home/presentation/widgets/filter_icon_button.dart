import 'package:delivery/src/core/presentation/widgets/drawer_state_acquirer.dart';
import 'package:flutter/material.dart';

class FilterIconButton extends StatelessWidget {
  final GlobalKey<ScaffoldState> childScaffoldKey;
  final GlobalKey<DrawerStateAcquirerState> drawerAcquirerKey;

  const FilterIconButton(
    this.childScaffoldKey,
    this.drawerAcquirerKey, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: MaterialLocalizations.of(context).showMenuTooltip,
      icon: const Icon(Icons.filter_list),
      onPressed: () {
        if (childScaffoldKey.currentState!.isEndDrawerOpen) {
          DrawerStateAcquirer.acquireDrawerCtrl(drawerAcquirerKey.currentState!).close();
        } else {
          childScaffoldKey.currentState!.openEndDrawer();
        }
      },
    );
  }
}
