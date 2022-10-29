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
import 'package:delivery/src/core/presentation/widgets/empty_tab.dart';
import 'package:delivery/src/features/filter/presentation/providers/providers.dart';
import 'package:delivery/src/features/home/presentation/slivers/sliver_products_heading_tile.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/page_body_template.dart';
import 'package:delivery/src/features/products/presentation/providers/providers.dart';
import 'package:delivery/src/features/products/presentation/slivers/sliver_products_list.dart';
import 'package:delivery/src/features/sticky_header/presentation/widgets/filters_sticky_header.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class FilteredProductsWithStickyHeader extends HookConsumerWidget {
  const FilteredProductsWithStickyHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(
        filteredProductsProvider(null).select((value) => value.itemsState));

    if (productsState.isDoneAndEmpty) {
      return Column(
        children: [
          const FiltersStickyHeader(filterType: FilterType.allProducts),
          EmptyTab(
            icon: Icons.block_rounded,
            message: context.l10n.noSuchItems,
            buttonMessage: context.l10n.modifyFilter,
            onButtonPressed: () =>
                // parent of parent scaffold
                Scaffold.of(context).openEndDrawer(),
          )
        ],
      );
    } else {
      final body = MultiSliver(
        children: [
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverProductsHeadingTile(
              title: context.l10n.filteredProducts,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverProductsList(
            productsState: productsState,
            requestData: () =>
                ref.read(filteredProductsProvider(null)).requestData(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      );

      return CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverStickyHeader(
            header:
                const FiltersStickyHeader(filterType: FilterType.allProducts),
            sliver: kIsWeb ? PageBodyTemplateSliver(sliver: body) : body,
          ),
        ],
      );
    }
  }
}
