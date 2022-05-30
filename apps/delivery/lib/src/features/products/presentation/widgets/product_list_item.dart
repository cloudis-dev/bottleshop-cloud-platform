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
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/widgets/list_item_container_decoration.dart';
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/products/presentation/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductListItem extends HookConsumerWidget {
  static const double imageWidth = 60;

  final ProductModel product;

  final List<TextSpan>? nameTextSpans;

  const ProductListItem({
    super.key,
    required this.product,
    this.nameTextSpans,
  });

  void onClick(WidgetRef ref, BuildContext context) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(currentLocaleProvider);

    return Container(
      decoration: ListItemContainerDecoration(context),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: imageWidth,
                  child: AspectRatio(
                    aspectRatio: productImageAspectRatio,
                    child: Hero(
                      tag: ValueKey(product.uniqueId),
                      child: ProductImage(imagePath: product.thumbnailPath),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (nameTextSpans?.isNotEmpty ?? false)
                              Text.rich(
                                TextSpan(
                                  text: '',
                                  style: Theme.of(context).textTheme.subtitle2,
                                  children: nameTextSpans,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                              )
                            else
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${FormattingUtils.getVolumeNumberString(product.unitsCount)} ${product.unitsType.getUnitAbbreviation(currentLocale)}',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  FormattingUtils.getAlcoholNumberString(
                                      product.alcohol ?? 0),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            Text(
                              product.count > 0
                                  ? '${product.count} ${context.l10n.inStock}'
                                  : context.l10n.outOfStock,
                              style: Theme.of(context)
                                  .textTheme
                                  .overline!
                                  .copyWith(
                                    color: product.count > 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              FormattingUtils.getPriceNumberString(
                                product.finalPrice,
                                withCurrency: true,
                              ),
                              style: Theme.of(context).textTheme.subtitle1),
                          if (product.discount != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                  FormattingUtils.getPriceNumberString(
                                    product.priceWithVat,
                                    withCurrency: true,
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                          decoration:
                                              TextDecoration.lineThrough)),
                            ),
                        ],
                      ),
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
