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
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/presentation/other/list_item_container_decoration.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/features/cart/presentation/providers/providers.dart';
import 'package:delivery/src/features/product_detail/presentation/pages/product_detail_page.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/products/presentation/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:routeborn/routeborn.dart';

class CartListItem extends HookWidget {
  final ProductModel product;
  final int quantity;

  const CartListItem({
    Key? key,
    required this.product,
    required this.quantity,
  })  : assert(quantity > 0),
        super(key: key);

  void onClick(BuildContext context) {
    context
        .read(navigationProvider)
        .pushPage(context, AppPageNode(page: ProductDetailPage(product)));
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = useProvider(currentLocaleProvider);
    final qtyState = useState<int>(quantity);
    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: ListItemContainerDecoration(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            width: 90,
            height: 90,
            child: AspectRatio(
              aspectRatio: productImageAspectRatio,
              child: Stack(
                children: [
                  Hero(
                    tag: HeroTags.productBaseTag + product.uniqueId,
                    child: ProductImage(imagePath: product.thumbnailPath),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkResponse(
                        containedInkWell: true,
                        child: InkWell(
                          onTap: () => onClick(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Text(
                  '${FormattingUtils.getVolumeNumberString(product.unitsCount)} ${product.unitsType.getUnitAbbreviation(currentLocale)} ${FormattingUtils.getAlcoholNumberString(product.alcohol ?? 0)}',
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  product.count > 0
                      ? '${product.count} ${S.of(context).inStock}'
                      : S.of(context).outOfStock,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: product.count > 0 ? Colors.green : Colors.red,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Column(
              mainAxisAlignment: qtyState.value > 1
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                Text(
                    FormattingUtils.getPriceNumberString(
                        double.parse(product.finalPrice.toStringAsFixed(2)),
                        withCurrency: true),
                    style: Theme.of(context).textTheme.subtitle1),
                if (product.discount != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                        FormattingUtils.getPriceNumberString(
                            double.parse(
                                product.priceWithVat.toStringAsFixed(2)),
                            withCurrency: true),
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(decoration: TextDecoration.lineThrough)),
                  ),
                if (qtyState.value > 1)
                  Text(
                      FormattingUtils.getPriceNumberString(
                          double.parse(product.finalPrice.toStringAsFixed(2)) *
                              int.parse(qtyState.value.toString()),
                          withCurrency: true),
                      style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Material(
                color: Theme.of(context).primaryColor,
                child: IconButton(
                  splashRadius: 10.0,
                  splashColor: Theme.of(context).colorScheme.secondary,
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: product.count <= qtyState.value
                      ? null
                      : () async {
                          return context
                              .read(cartRepositoryProvider)!
                              .setItemQty(product.uniqueId, qtyState.value + 1);
                        },
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ),
              Text(qtyState.value.toString(),
                  style: Theme.of(context).textTheme.bodyText1),
              Material(
                color: Theme.of(context).primaryColor,
                child: IconButton(
                  splashRadius: 10.0,
                  splashColor: Theme.of(context).colorScheme.secondary,
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () async {
                    if (qtyState.value == 1) {
                      await context
                          .read(cartRepositoryProvider)!
                          .removeItem(product.uniqueId);
                    } else {
                      //qtyState.value = qtyState.value - 1;
                      return context
                          .read(cartRepositoryProvider)!
                          .setItemQty(product.uniqueId, qtyState.value - 1);
                    }
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
