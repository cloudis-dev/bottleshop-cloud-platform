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
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/data/services/analytics_service.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/features/product_detail/presentation/pages/product_detail_page.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/products/presentation/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:routeborn/routeborn.dart';

class ProductGridItem extends HookConsumerWidget {
  /// For rectangular image the value .56 is fine
  static const double widgetAspectRatio = .485;

  final ProductModel product;

  const ProductGridItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  void onClick(BuildContext context, WidgetRef ref) {
    ref
        .read(navigationProvider)
        .pushPage(context, AppPageNode(page: ProductDetailPage(product)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitleTheme = Theme.of(context).textTheme.subtitle1!;
    final headline6Theme = Theme.of(context).textTheme.headline6!;
    final body1Theme = Theme.of(context).textTheme.bodyText1!;
    final stockTextTheme = Theme.of(context).textTheme.bodyText2!.copyWith(
          color: product.count > 0 ? Colors.green : Colors.red,
        );

    final currentLang = ref.watch(currentLanguageProvider);

    const fit = BoxFit.fitHeight;

    return Align(
      alignment: Alignment.topCenter,
      child: AspectRatio(
        aspectRatio: widgetAspectRatio,
        child: Container(
          decoration: BoxDecoration(
            border:
                Border.all(color: Theme.of(context).hintColor.withOpacity(0.2)),
            color: Theme.of(context).primaryColor,
            borderRadius: ProductImage.borderRadius,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.20),
                offset: const Offset(0, 6),
                blurRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: productImageAspectRatio,
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: <Widget>[
                        Hero(
                          tag: HeroTags.productBaseTag + product.uniqueId,
                          child: ProductImage(imagePath: product.thumbnailPath),
                        ),
                        if (product.discount != null)
                          Positioned(
                            top: 6,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              alignment: AlignmentDirectional.topEnd,
                              child: Text(
                                '- ${(product.discount! * 100).toStringAsFixed(2)} %',
                                style: Theme.of(context).textTheme.overline,
                              ),
                            ),
                          ),
                        if (product.isSpecialEdition)
                          const Positioned(
                            top: 0,
                            left: 0,
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(kSpecialEdition),
                                  ),
                                ),
                                child: SizedBox(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const AspectRatio(aspectRatio: 20),
                  Expanded(
                    flex: (subtitleTheme.fontSize! * 2.2).toInt(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: LayoutBuilder(
                        builder: (context, constraints) => Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: subtitleTheme.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: constraints.maxHeight / 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: body1Theme.fontSize!.toInt(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FittedBox(
                            fit: fit,
                            child: Text(
                              '${FormattingUtils.getVolumeNumberString(product.unitsCount)} ${product.unitsType.getUnitAbbreviation(currentLang)}',
                              style: Theme.of(context).textTheme.bodySmall,
                              // body1Theme,
                            ),
                          ),
                          FittedBox(
                            fit: fit,
                            child: Text(
                              FormattingUtils.getAlcoholNumberString(
                                  product.alcohol ?? 0),
                              style: Theme.of(context).textTheme.bodySmall,
                              // body1Theme,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: stockTextTheme.fontSize!.toInt(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: FittedBox(
                        fit: fit,
                        child: Text(
                          product.count > 0
                              ? '${product.count} ${context.l10n.inStock}'
                              : context.l10n.outOfStock,
                          style: stockTextTheme,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: headline6Theme.fontSize!.toInt(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(
                            fit: fit,
                            child: Text(
                              FormattingUtils.getPriceNumberString(
                                product.finalPrice,
                                withCurrency: true,
                              ),
                              style: headline6Theme,
                            ),
                          ),
                          if (product.discount != null)
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: FittedBox(
                                  fit: fit,
                                  child: Text(
                                    FormattingUtils.getPriceNumberString(
                                      product.priceWithVat,
                                      withCurrency: true,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            decoration:
                                                TextDecoration.lineThrough),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  const AspectRatio(aspectRatio: 15),
                ],
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await logViewItem(
                        context,
                        product.uniqueId,
                        product.name,
                        product.allCategories.first.categoryDetails
                            .getName(currentLang),
                      );
                      onClick(context, ref);
                    },
                    borderRadius: ProductImage.borderRadius,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
