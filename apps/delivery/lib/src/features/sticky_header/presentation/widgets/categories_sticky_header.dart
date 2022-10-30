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

import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/categories/presentation/pages/categories_page.dart';
import 'package:delivery/src/features/categories/presentation/providers/providers.dart';
import 'package:delivery/src/features/products/presentation/pages/category_products_detail_page.dart';
import 'package:delivery/src/features/products/presentation/widgets/category_chip.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:routeborn/routeborn.dart';

final _logger = Logger((CategoriesStickyHeader).toString());

class CategoriesStickyHeader extends HookConsumerWidget {
  const CategoriesStickyHeader({
    Key? key,
  }) : super(key: key);

  void onNavigateToCategory(
    BuildContext context,
    WidgetRef ref,
    CategoriesTreeModel category,
    String heroTag,
  ) {
    ref
        .read(navigationProvider)
        .setNestingBranch(context, NestingBranch.categories);

    ref.read(navigationProvider).replaceAllWith(context, [
      AppPageNode(page: CategoriesPage()),
      AppPageNode(
        page: CategoryProductsPage(
          category,
          categoryImgHeroTag: heroTag,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(mainCategoriesWithoutExtraProvider);

    return SizedBox(
      height: 65,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.center,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: (categories.length) + 1,
                itemBuilder: (context, index) {
                  _logger
                      .fine('categories: ${categories.length} index: $index');
                  if (index == (categories.length)) {
                    return const SizedBox(
                      width: 12,
                    );
                  } else {
                    final category = categories.elementAt(index);
                    final heroTag =
                        '${category.categoryDetails.id}_categoryStickyHeader';

                    return CategoryChip(
                      onNavigateToCategory: (context) =>
                          onNavigateToCategory(context, ref, category, heroTag),
                      category: categories.elementAt(index),
                      heroTag: heroTag,
                    );
                  }
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
