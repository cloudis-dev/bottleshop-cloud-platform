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
import 'package:delivery/src/core/presentation/widgets/bottleshop_section_heading.dart';
import 'package:delivery/src/features/products/presentation/widgets/products_layout_mode_toggle.dart';
import 'package:delivery/src/features/sorting/presentation/widgets/sort_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SliverCategoryTabHeading extends HookWidget {
  const SliverCategoryTabHeading({
    Key? key,
    required this.subCategory,
  }) : super(key: key);

  final CategoriesTreeModel? subCategory;

  @override
  Widget build(BuildContext context) {
    final currentLocale = useProvider(currentLocaleProvider);

    return SliverToBoxAdapter(
      child: BottleshopSectionHeading(
        leading: const Icon(Icons.liquor),
        label:
            '${subCategory!.categoryDetails.getName(currentLocale)} ${S.of(context).category}',
        trailingWidgets: <Widget>[
          const ProductsLayoutModeToggle(),
          const SortMenuButton()
        ],
      ),
      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 20),
      //   child: ListTile(
      //     dense: true,
      //     contentPadding: EdgeInsets.symmetric(vertical: 0),
      //     leading: const Icon(
      //       Icons.liquor,
      //     ),
      //     title: Text(
      //       '${subCategory!.categoryDetails.getName(currentLocale)} ${S.of(context).category}',
      //       overflow: TextOverflow.fade,
      //       softWrap: false,
      //       style: Theme.of(context).textTheme.headline6,
      //     ),
      //     trailing: Row(
      //       mainAxisSize: MainAxisSize.min,
      //       children: <Widget>[
      //         const ProductsLayoutModeToggle(),
      //         const SortMenuButton()
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
