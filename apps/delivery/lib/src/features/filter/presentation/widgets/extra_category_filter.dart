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
import 'package:delivery/src/core/data/repositories/common_data_repository.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/filter/presentation/filter_drawer.dart';
import 'package:delivery/src/features/filter/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExtraCategoriesGroupFilter extends HookConsumerWidget {
  const ExtraCategoriesGroupFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(commonDataRepositoryProvider
        .select<List<CategoriesTreeModel>>((value) => value.data.categories));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.onlyFollowingExtraCategories),
          const SizedBox(height: 8),
          ...categories
              .where((element) => element.categoryDetails.isExtraCategory)
              .map(
                (e) => _ExtraCategoryFilter(
                  category: e,
                ),
              )
        ],
      ),
    );
  }
}

class _ExtraCategoryFilter extends HookConsumerWidget {
  const _ExtraCategoryFilter({
    Key? key,
    this.category,
  }) : super(key: key);

  final CategoriesTreeModel? category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterType = ref.watch(filterTypeScopedProvider);

    final currentLocale = ref.watch(currentLocaleProvider);

    final enabledCategoriesIds = ref.watch(
      filterModelProvider(filterType)
          .select<List<String>>((value) => value.enabledExtraCategoriesIds),
    );

    final categoryTreeIds =
        CategoriesTreeModel.getAllCategoryPlainModels(category!)
            .map((e) => e.id)
            .toList();

    final intersection =
        enabledCategoriesIds.toSet().intersection(categoryTreeIds.toSet());

    /// Null for tristate - at least one sub selected.
    final mainCategoryState = intersection.length == categoryTreeIds.length
        ? true
        : (intersection.isEmpty ? false : null);

    void addWholeCategoryTree(WidgetRef ref) {
      ref.read(filterModelProvider(filterType).state).state =
          ref.read(filterModelProvider(filterType).state).state.copyWith(
                enabledExtraCategoriesIds: enabledCategoriesIds
                    .toSet()
                    .union(categoryTreeIds.toSet())
                    .toList(),
              );
    }

    void removeWholeCategoryTree(WidgetRef ref) {
      ref.read(filterModelProvider(filterType).state).state =
          ref.read(filterModelProvider(filterType).state).state.copyWith(
                enabledExtraCategoriesIds: enabledCategoriesIds
                    .toSet()
                    .difference(categoryTreeIds.toSet())
                    .toList(),
              );
    }

    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              onChanged: (value) {
                if (value ?? false) {
                  addWholeCategoryTree(ref);
                } else {
                  removeWholeCategoryTree(ref);
                }
              },
              value: mainCategoryState,
              tristate: true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  category!.categoryDetails.getName(currentLocale),
                ),
              ),
            ),
          ],
        ),
        ...category!.subCategories.map(
          (e) => Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Row(
              children: [
                Checkbox(
                  onChanged: (value) {
                    if (value!) {
                      if (intersection.length < categoryTreeIds.length - 2) {
                        // When not the last subcategory selected, then add just this one.
                        ref.read(filterModelProvider(filterType).state).state =
                            ref
                                .read(filterModelProvider(filterType).state)
                                .state
                                .copyWith(
                                  enabledExtraCategoriesIds:
                                      enabledCategoriesIds.followedBy(
                                          [e.categoryDetails.id]).toList(),
                                );
                      } else {
                        // When all the subcategories selected, select also the main one.
                        addWholeCategoryTree(ref);
                      }
                    } else {
                      // When at least one removed, remove also the main category.
                      ref.read(filterModelProvider(filterType).state).state =
                          ref
                              .read(filterModelProvider(filterType).state)
                              .state
                              .copyWith(
                                enabledExtraCategoriesIds: enabledCategoriesIds
                                    .toSet()
                                    .difference({
                                  category!.categoryDetails.id,
                                  e.categoryDetails.id
                                }).toList(),
                              );
                    }
                  },
                  value: enabledCategoriesIds.contains(e.categoryDetails.id),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      e.categoryDetails.getName(currentLocale),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
