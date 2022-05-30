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
import 'package:delivery/src/core/data/services/streamed_items_state_management/data/items_state.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/widgets/empty_tab.dart';
import 'package:delivery/src/core/presentation/widgets/sliver_obstruction_injector.dart';
import 'package:delivery/src/core/presentation/widgets/sliver_resizable_pinned_header_padding.dart';
import 'package:delivery/src/features/filter/presentation/providers/providers.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/products/presentation/providers/providers.dart';
import 'package:delivery/src/features/products/presentation/slivers/sliver_category_tab_heading.dart';
import 'package:delivery/src/features/products/presentation/slivers/sliver_products_list.dart';
import 'package:delivery/src/features/sticky_header/presentation/widgets/filters_sticky_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

bool _shouldDisplayListWithSubcategories(
    bool isAllCategory, List<CategoriesTreeModel> subCategories) {
  return !isAllCategory && subCategories.isNotEmpty;
}

const _categoryTabHeadingPadding = EdgeInsets.symmetric(vertical: 12);
const _filtersStickyHeaderPadding = 12.0;

class CategoryProductsList extends HookConsumerWidget {
  const CategoryProductsList({
    Key? key,
    required this.category,
    required this.isAllCategory,
  }) : super(key: key);

  final bool isAllCategory;
  final CategoriesTreeModel category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appliedFilter = ref
        .watch(appliedFilterProvider(FilterType.categoryProducts).state)
        .state;
    final hasProducts = ref
        .watch(
          categoryHasProductsProvider(
            _shouldDisplayListWithSubcategories(
              isAllCategory,
              category.subCategories,
            )
                ? category.subCategories.map((e) => e.categoryDetails).toList()
                : [category.categoryDetails],
          ).state,
        )
        .state;

    return SafeArea(
      top: false,
      bottom: false,
      child: !hasProducts
          ? CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                // This is for the sticky header to stop right under app bar
                SliverObstructionInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                const _NoProductsBody(),
              ],
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              key: PageStorageKey<String?>(
                category.categoryDetails.id,
              ),
              slivers: [
                // This is for the sticky header to stop right under app bar
                SliverObstructionInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                if (appliedFilter.isAnyFilterActive)
                  _ProductsBodyWithFilter(
                    category: category,
                    isAllCategory: isAllCategory,
                  )
                else
                  _ProductsBody(
                    category: category,
                    isAllCategory: isAllCategory,
                  )
              ],
            ),
    );
  }
}

class _ProductsBodyWithFilter extends StatelessWidget {
  const _ProductsBodyWithFilter({
    Key? key,
    required this.category,
    required this.isAllCategory,
  }) : super(key: key);

  final bool isAllCategory;
  final CategoriesTreeModel category;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        if (_shouldDisplayListWithSubcategories(
          isAllCategory,
          category.subCategories,
        ))
          SliverResizablePinnedHeaderPadding(
            maxShift: 56 - _filtersStickyHeaderPadding,
            shiftDelay: 48 +
                _categoryTabHeadingPadding.top +
                _categoryTabHeadingPadding.bottom,
            child: Container(),
          ),
        SliverStickyHeader(
          header: const Padding(
            padding: EdgeInsets.only(top: _filtersStickyHeaderPadding),
            child: FiltersStickyHeader(
              filterType: FilterType.categoryProducts,
            ),
          ),
          sliver: MultiSliver(
            children: [
              _CategoryHeading(
                category: category,
              ),
              _ProductsListWithSubcategoriesStickyHeaders(
                category: category,
                isAllCategory: isAllCategory,
              ),
            ],
          ),
        ),
        // This is to enable scrolling at the bottom of size of the app bar
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _ProductsBody extends StatelessWidget {
  const _ProductsBody({
    Key? key,
    required this.category,
    required this.isAllCategory,
  }) : super(key: key);

  final bool isAllCategory;
  final CategoriesTreeModel category;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        _CategoryHeading(
          category: category,
        ),
        _ProductsListWithSubcategoriesStickyHeaders(
          category: category,
          isAllCategory: isAllCategory,
        ),
        // This is to enable scrolling at the bottom of size of the app bar
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _NoProductsBody extends HookConsumerWidget {
  static const double _bottomPad = 150;

  const _NoProductsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appliedFilter = ref
        .watch(appliedFilterProvider(FilterType.categoryProducts).state)
        .state;

    if (appliedFilter.isAnyFilterActive) {
      return MultiSliver(
        children: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: _filtersStickyHeaderPadding),
              child:
                  FiltersStickyHeader(filterType: FilterType.categoryProducts),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.only(
                    bottom:
                        NestedScrollView.sliverOverlapAbsorberHandleFor(context)
                            .layoutExtent!,
                  ) +
                  const EdgeInsets.only(bottom: _bottomPad),
              child: EmptyTab(
                icon: Icons.block_rounded,
                message: context.l10n.noSuchItems,
                buttonMessage: context.l10n.modifyFilter,
                onButtonPressed: () =>
                    // parent of parent scaffold
                    Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ),
        ],
      );
    } else {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: EdgeInsets.only(
                bottom: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
                    .layoutExtent!,
              ) +
              const EdgeInsets.only(bottom: _bottomPad),
          child: EmptyTab(
            icon: Icons.block_rounded,
            message: context.l10n.noSuchItems,
            buttonMessage: context.l10n.modifyFilter,
            onButtonPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      );
    }
  }
}

class _CategoryHeading extends HookWidget {
  const _CategoryHeading({
    Key? key,
    required this.category,
  }) : super(key: key);

  final CategoriesTreeModel? category;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: _categoryTabHeadingPadding,
      sliver: SliverCategoryTabHeading(
        subCategory: category,
      ),
    );
  }
}

class _ProductsListWithSubcategoriesStickyHeaders extends HookConsumerWidget {
  const _ProductsListWithSubcategoriesStickyHeaders({
    Key? key,
    required this.category,
    required this.isAllCategory,
  }) : super(key: key);

  final CategoriesTreeModel category;
  final bool isAllCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAnyFilterActive = ref.watch(
        appliedFilterProvider(FilterType.categoryProducts)
            .select<bool>((value) => value.isAnyFilterActive));

    final currentLocale = ref.watch(currentLocaleProvider);

    if (_shouldDisplayListWithSubcategories(
      isAllCategory,
      category.subCategories,
    )) {
      final providers = category.subCategories
          .map((e) => isAnyFilterActive
              ? filteredProductsProvider(e.categoryDetails)
              : productsByCategoryProvider(e.categoryDetails))
          .toList();

      final productsStates = providers
          .map(
            (provider) => ref.watch(provider
                .select<ItemsState<ProductModel>>((value) => value.itemsState)),
          )
          .toList();

      return MultiSliver(
        children: Iterable<int>.generate(productsStates.length)
            .where((id) => !productsStates[id].isDoneAndEmpty)
            .map(
              (id) => SliverStickyHeader(
                overlapsContent: false,
                header: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ListTile(
                    title: Text(
                      category.subCategories[id].categoryDetails
                          .getName(currentLocale),
                    ),
                  ),
                ),
                sliver: SliverProductsList(
                  productsState: productsStates[id],
                  requestData: () => ref.read(providers[id]).requestData(),
                ),
              ),
            )
            .toList(),
      );
    } else {
      final provider = isAnyFilterActive
          ? filteredProductsProvider(category.categoryDetails)
          : productsByCategoryProvider(category.categoryDetails);

      final productsState = ref.watch(
        provider.select<ItemsState<ProductModel>>((value) => value.itemsState),
      );

      return SliverProductsList(
        productsState: productsState,
        requestData: () => ref.read(provider).requestData(),
      );
    }
  }
}
