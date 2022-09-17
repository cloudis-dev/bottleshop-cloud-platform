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

import 'dart:math';

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryGridItem extends HookWidget {
  final CategoriesTreeModel category;
  final void Function(
    BuildContext context,
    CategoriesTreeModel category,
  ) onNavigateToCategory;
  final AsyncValue<int?>? productsCount;
  final double maxSize;
  final int titleMaxLines;

  const CategoryGridItem({
    Key? key,
    required this.category,
    required this.onNavigateToCategory,
    required this.productsCount,
    required this.maxSize,
    this.titleMaxLines = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentLocale = useProvider(currentLocaleProvider);

    return Material(
      child: InkWell(
        onTap: () => onNavigateToCategory(context, category),
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
              right: -40,
              bottom: -60,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
            ),
            Positioned(
              left: -30,
              top: -60,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Align(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: category.categoryDetails.id,
                        child: ImageIcon(
                          AssetImage(category.categoryDetails.iconName!),
                          color: Theme.of(context).primaryIconTheme.color,
                          size: maxSize * .3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.categoryDetails.getName(currentLocale),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: titleMaxLines,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: max(maxSize * .1, 15)),
                      ),
                      if (productsCount != null)
                        DefaultTextStyle(
                          style: Theme.of(context).textTheme.bodyText2!,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${context.l10n.products}: '),
                              productsCount!.maybeWhen(
                                data: (count) => Text(
                                  count.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                orElse: () => const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
