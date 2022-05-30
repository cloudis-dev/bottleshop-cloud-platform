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

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:delivery/src/core/data/models/category_plain_model.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/widgets/list_item_container_decoration.dart';
import 'package:delivery/src/features/categories/presentation/other/category_container_decoration.dart';
import 'package:delivery/src/features/products/presentation/widgets/product_list_item.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchedCategoryListItem extends HookConsumerWidget {
  const SearchedCategoryListItem({
    required this.categoryPlainModel,
    required this.navigationCategory,
    required this.heroTag,
    this.bottomSideLineWidth,
  });

  final CategoryPlainModel categoryPlainModel;
  final CategoriesTreeModel navigationCategory;
  final double? bottomSideLineWidth;
  final String heroTag;

  void onClick(WidgetRef ref, BuildContext context) {
    final subcategoryId = navigationCategory.categoryDetails.id != categoryPlainModel.id
        ? navigationCategory.subCategories
            .map((e) => CategoriesTreeModel.getAllCategoryPlainModels(e).map((e) => e.id))
            .toList()
            .indexWhere((element) => element.contains(categoryPlainModel.id))
        : null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(currentLocaleProvider);

    return Container(
      decoration: ListItemContainerDecoration(
        context,
        bottomSideLineWidth: bottomSideLineWidth,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: CategoryContainerDecoration(context).copyWith(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: SizedBox(
                    width: ProductListItem.imageWidth,
                    child: AspectRatio(
                      aspectRatio: productImageAspectRatio,
                      child: Hero(
                        tag: heroTag,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Image.asset(
                            categoryPlainModel.iconName!,
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        navigationCategory.categoryDetails.getName(currentLocale),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (categoryPlainModel.id == navigationCategory.categoryDetails.id)
                        Text(
                          context.l10n.all,
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      else
                        Text(
                          categoryPlainModel.getName(currentLocale),
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(onTap: () => onClick(ref, context)),
            ),
          ),
        ],
      ),
    );
  }
}
