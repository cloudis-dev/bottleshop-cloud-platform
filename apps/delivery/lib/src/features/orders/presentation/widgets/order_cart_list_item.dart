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

import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/presentation/other/list_item_container_decoration.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/features/cart/data/models/cart_item_model.dart';
import 'package:delivery/src/features/products/presentation/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderCartListItem extends HookWidget {
  const OrderCartListItem(this.cartItem, {Key? key}) : super(key: key);

  final CartItemModel cartItem;

  @override
  Widget build(BuildContext context) {
    final currentLocale = useProvider(currentLocaleProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: ListItemContainerDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            child: AspectRatio(
              aspectRatio: productImageAspectRatio,
              child: ProductImage(imagePath: cartItem.product.thumbnailPath),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${FormattingUtils.getVolumeNumberString(cartItem.product.unitsCount)} ${cartItem.product.unitsType.getUnitAbbreviation(currentLocale)}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      FormattingUtils.getAlcoholNumberString(
                          cartItem.product.alcohol ?? 0),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                        FormattingUtils.getPriceNumberString(
                          cartItem.product.finalPrice,
                          withCurrency: true,
                        ),
                        style: Theme.of(context).textTheme.bodyText1),
                    const SizedBox(width: 10),
                    if (cartItem.product.discount != null)
                      Text(
                        FormattingUtils.getPriceNumberString(
                          cartItem.product.priceWithVat,
                          withCurrency: true,
                        ),
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                FormattingUtils.getPriceNumberString(
                  cartItem.paidPrice,
                  withCurrency: true,
                ),
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Chip(
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary)),
                  label: Text(
                    '${cartItem.count}x',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
