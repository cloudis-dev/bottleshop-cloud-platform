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

import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/product_sections/presentation/widgets/molecules/section_product_item.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/products/presentation/widgets/product_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProductsSectionCarousel extends HookWidget {
  final List<ProductModel> data;
  final Widget carouselHeader;

  const ProductsSectionCarousel({
    Key? key,
    required this.carouselHeader,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    } else {
      Widget child;

      if (shouldUseMobileLayout(context)) {
        child = SizedBox(
          height: 320 +
              (data.any((element) => element.isFlashSale) ? 40 : 0).toDouble(),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (context, id) {
              const spacing = 20.0;
              final marginLeft = (id == 0) ? spacing : 0;

              return SectionProductItem(
                product: data[id],
                margin: EdgeInsets.only(
                    left: marginLeft.toDouble(), right: spacing),
              );
            },
          ),
        );
      } else {
        child = GridView.builder(
          padding: const EdgeInsets.only(left: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, idx) {
            return SectionProductItem(
              product: data[idx],
              margin: EdgeInsets.zero,
            );
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 5,
            crossAxisSpacing: 10,
            maxCrossAxisExtent: 175,
            childAspectRatio: .53,
          ),
        );
      }

      return Column(
        children: [
          carouselHeader,
          child,
        ],
      );
    }
  }
}
