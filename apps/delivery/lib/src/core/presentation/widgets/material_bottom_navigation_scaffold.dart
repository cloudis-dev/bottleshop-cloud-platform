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

import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/bottom_navigation_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MaterialBottomNavigationScaffold extends HookWidget {
  const MaterialBottomNavigationScaffold({
    required this.navigationBarItems,
    required this.onItemSelected,
    required this.selectedBranch,
    Key? key,
  }) : super(key: key);

  final List<BottomNavigationTab> navigationBarItems;
  final ValueChanged<NestingBranch> onItemSelected;
  final NestingBranch selectedBranch;

  @override
  Widget build(BuildContext context) {
    final routerKey = useMemoized(() => GlobalKey());
    final scaffoldKey = useMemoized(() => GlobalKey());

    final currentId = navigationBarItems
        .indexWhere((e) => e.navigationNestingLevel == selectedBranch);

    if (currentId == -1) {
      return Router(
        key: routerKey,
        routerDelegate: useProvider(nestedRouterDelegate(null)),
      );
    } else {
      return Scaffold(
        key: scaffoldKey,
        body: IndexedStack(
          index: currentId,
          children: navigationBarItems
              .map(
                (barItem) => Router(
                  routerDelegate: useProvider(
                      nestedRouterDelegate(barItem.navigationNestingLevel)),
                ),
              )
              .toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedFontSize: 14,
          unselectedFontSize: 11,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Colors.grey,
          iconSize: 24,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          currentIndex: currentId,
          items: navigationBarItems
              .map((item) => item.bottomNavigationBarItem)
              .toList(),
          onTap: (id) =>
              onItemSelected(navigationBarItems[id].navigationNestingLevel),
        ),
      );
    }
  }
}
