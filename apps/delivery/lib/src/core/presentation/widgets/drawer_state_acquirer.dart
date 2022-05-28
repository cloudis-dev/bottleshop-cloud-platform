import 'package:flutter/material.dart';

class DrawerStateAcquirer extends StatefulWidget {
  final Widget child;

  const DrawerStateAcquirer({
    Key? key,
    required this.child,
  }) : super(key: key);

  static DrawerControllerState acquireDrawerCtrl(
    DrawerStateAcquirerState acquirerState,
  ) {
    return acquirerState.context
        .findAncestorStateOfType<DrawerControllerState>()!;
  }

  @override
  State<StatefulWidget> createState() => DrawerStateAcquirerState();
}

class DrawerStateAcquirerState extends State<DrawerStateAcquirer> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
