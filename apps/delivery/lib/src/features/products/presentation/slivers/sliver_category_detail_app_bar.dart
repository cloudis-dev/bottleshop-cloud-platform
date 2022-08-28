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

import 'package:delivery/generated/l10n.dart';
import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/products/presentation/widgets/subcategories_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SliverCategoryDetailAppBar extends HookWidget {
  const SliverCategoryDetailAppBar({
    Key? key,
    required this.category,
    required this.tabController,
    required this.categoryImgHeroTag,
    required this.actions,
  }) : super(key: key);

  final CategoriesTreeModel? category;
  final TabController? tabController;
  final String? categoryImgHeroTag;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final currentLocale = useProvider(currentLocaleProvider);
    return SliverAppBar(
      snap: false,
      floating: false,
      pinned: true,
      leading: BackButton(
        onPressed: () => context.read(navigationProvider).popPage(context),
      ),
      actions: actions,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      expandedHeight: 250,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(10),
                //     bottomLeft: Radius.circular(10)),
                // boxShadow: [
                //   BoxShadow(
                //       color: Theme.of(context).primaryColor.withOpacity(0.10),
                //       offset: Offset(0, 4),
                //       blurRadius: 10)
                // ],
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: const [.25, 1],
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).primaryColor.withOpacity(.9),
                  ],
                ),
              ),
              child: const SizedBox.shrink(),
            ),
            Positioned(
              right: -60,
              bottom: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(300),
                ),
              ),
            ),
            Positioned(
              left: -30,
              top: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 30),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: categoryImgHeroTag!,
                    child: ImageIcon(
                      AssetImage(category!.categoryDetails.iconName!),
                      color: Theme.of(context).primaryIconTheme.color,
                      size: 90,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category!.categoryDetails.getName(currentLocale),
                    style: Theme.of(context).textTheme.headline6,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottom: tabController == null
          ? null
          : SubcategoriesTabBar(
              category!,
              _TabWrapper(
                child: Tab(child: Text(S.of(context).all.toUpperCase())),
              ),
              (e) => _TabWrapper(
                child: Tab(
                  child: Text(
                    e.categoryDetails.getName(currentLocale).toUpperCase(),
                  ),
                ),
              ),
              controller: tabController,
              indicatorWeight: 5,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor:
                  Theme.of(context).primaryColor.withOpacity(0.6),
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w300),
              isScrollable: true,
              indicatorColor: Theme.of(context).primaryColor,
            ),
    );
  }
}

class _TabWrapper extends StatelessWidget {
  const _TabWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Tab child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 90),
      child: child,
    );
  }
}
