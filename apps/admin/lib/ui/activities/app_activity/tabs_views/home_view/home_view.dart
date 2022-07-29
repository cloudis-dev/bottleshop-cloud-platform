import 'package:bottleshop_admin/ui/shared_widgets/app_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomeView extends HookWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Domov'),
        ),
        drawer: const AppNavigationDrawer(),
        body: Container(),
      ),
    );
  }
}
