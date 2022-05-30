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

import 'package:delivery/src/core/data/models/preferences.dart';
import 'package:delivery/src/core/data/services/streamed_items_state_management/data/items_state.dart';
import 'package:delivery/src/core/data/services/streamed_items_state_management/presentation/slivers/implementations/sliver_paged_grid.dart';
import 'package:delivery/src/core/data/services/streamed_items_state_management/presentation/slivers/implementations/sliver_paged_list.dart';
import 'package:delivery/src/core/presentation/widgets/list_error_widget.dart';
import 'package:delivery/src/core/presentation/widgets/list_loading_widget.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/products/presentation/providers/providers.dart';
import 'package:delivery/src/features/products/presentation/widgets/product_grid_item.dart';
import 'package:delivery/src/features/products/presentation/widgets/product_list_item.dart';
import 'package:delivery/src/features/products/utils/product_sliver_grid_delegate.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SliverProductsList extends HookConsumerWidget {
  const SliverProductsList({
    Key? key,
    required this.productsState,
    required this.requestData,
  }) : super(key: key);

  final ItemsState<ProductModel> productsState;
  final void Function() requestData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutMode = ref.watch(productsLayoutModeProvider.state).state;

    if (layoutMode == SupportedLayoutMode.list) {
      return SliverPagedList<ProductModel>(
        itemsState: productsState,
        requestData: requestData,
        itemBuilder: (context, dynamic item, _) => ProductListItem(
          product: item,
        ),
        errorWidgetBuilder: (context, onPressed) => ListErrorWidget(onPressed),
        loadingWidgetBuilder: (_) => const ListLoadingWidget(),
      );
    } else {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        sliver: SliverPagedGrid<ProductModel>(
          itemsState: productsState,
          requestData: requestData,
          itemBuilder: (context, item, _) => ProductGridItem(
            product: item,
          ),
          gridDelegate: const ProductSliverGridDelegate(),
          errorWidgetBuilder: (context, onPressed) => ListErrorWidget(onPressed),
          loadingWidgetBuilder: (_) => const ListLoadingWidget(),
        ),
      );
    }
  }
}
