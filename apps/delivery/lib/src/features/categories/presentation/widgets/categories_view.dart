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
import 'package:delivery/src/features/categories/presentation/providers/providers.dart';
import 'package:delivery/src/features/categories/presentation/widgets/category_grid_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';

class CategoriesView extends HookConsumerWidget with UiLoggy {
  final ScrollController? scrollCtrl;

  const CategoriesView({
    Key? key,
    this.scrollCtrl,
  }) : super(key: key);

  void onNavigateToCategory(
    WidgetRef ref,
    BuildContext context,
    CategoriesTreeModel category,
  ) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories =
        ref.watch(mainCategoriesWithoutExtraProvider.state).state;
    final productCounts = ref.watch(categoryProductCountsProvider);

    const maxSize = 200.0;

    return GridView.builder(
      controller: scrollCtrl,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxSize,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
      itemCount: categories.length,
      itemBuilder: (context, id) {
        final category = categories[id];

        return CategoryGridItem(
          category: category,
          onNavigateToCategory: onNavigateToCategory,
          productsCount: productCounts.map(
            data: (res) => AsyncValue.data(
              res.value.getProductsCount(category.categoryDetails.id),
            ),
            error: (err) {
              loggy.error('Failed to fetch products counts', err);
              return const AsyncValue.loading();
            },
            loading: (value) => const AsyncValue.loading(),
          ),
          maxSize: maxSize,
        );
      },
    );
  }
}
