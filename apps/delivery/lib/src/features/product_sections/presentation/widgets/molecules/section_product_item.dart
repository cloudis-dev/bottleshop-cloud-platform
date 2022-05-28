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
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/features/product_sections/presentation/providers/providers.dart';
import 'package:delivery/src/features/product_sections/presentation/widgets/atoms/available_progress_bar.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/products/presentation/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger((SectionProductIteml10n.toString());

class SectionProductItem extends HookConsumerWidget {
  static const double imageWidth = 160;

  final EdgeInsets margin;
  final ProductModel product;

  const SectionProductItem({
    Key? key,
    required this.margin,
    required this.product,
  }) : super(key: key);

  void onClick(WidgetRef ref, BuildContext context) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(currentLocaleProvider);

    return Container(
      margin: margin,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          SizedBox(
            width: imageWidth,
            child: AspectRatio(
              aspectRatio: productImageAspectRatio,
              child: Stack(
                children: [
                  Hero(
                    tag: ValueKey(product.uniqueId),
                    child: ProductImage(imagePath: product.thumbnailPath),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onClick(ref, context),
                        borderRadius: ProductImage.borderRadius,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (product.discount != null)
            Positioned(
              top: 6,
              right: 5,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(100)),
                      color: Theme.of(context).colorScheme.secondary),
                  alignment: AlignmentDirectional.topEnd,
                  child: Text(
                    '- ${(product.discount! * 100l10n.toStringAsFixed(2)}%',
                    style: Theme.of(context).textTheme.overline,
                  ),
                ),
              ),
            ),
          if (product.isSpecialEdition)
            Positioned(
              top: 0,
              left: 0,
              child: IgnorePointer(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/special.png')),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 13,
            child: Stack(
              children: [
                Column(
                  children: [
                    if (product.isFlashSale)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                        width: imageWidth - 20,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: ProductImage.borderRadius,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).hintColor.withOpacity(0.15),
                                offset: const Offset(0, 3),
                                blurRadius: 10)
                          ],
                        ),
                        child: _FlashSaleItem(product),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      width: imageWidth - 20,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: ProductImage.borderRadius,
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).hintColor.withOpacity(0.1),
                              offset: const Offset(0, 3),
                              blurRadius: 10)
                        ],
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.subtitle2,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '${FormattingUtils.getVolumeNumberString(product.unitsCount)} ${product.unitsType.getUnitAbbreviation(currentLocale)}',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                if (product.alcohol != null)
                                  Text(
                                    FormattingUtils.getAlcoholNumberString(product.alcohol),
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                              ],
                            ),
                            Text(
                              product.count > 0
                                  ? '${product.count} ${context.l10n.inStock}'
                                  : context.l10n.outOfStock,
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                    color: product.count > 0 ? Colors.green : Colors.red,
                                  ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  FormattingUtils.getPriceNumberString(
                                    product.finalPrice,
                                    withCurrency: true,
                                  ),
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                if (product.discount != null)
                                  Expanded(
                                    child: Text(
                                      FormattingUtils.getPriceNumberString(
                                        product.priceWithVat,
                                        withCurrency: true,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(decoration: TextDecoration.lineThrough),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                    ),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onClick(ref, context),
                      borderRadius: ProductImage.borderRadius,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _FlashSaleItem extends HookConsumerWidget {
  final ProductModel product;

  const _FlashSaleItem(this.product);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(flashSaleEndProvider(product.flashSale!));

    return value.maybeWhen(
        data: (flashSaleEndsIn) {
          if (product.isFlashSale && flashSaleEndsIn.inSeconds > 0) {
            return Column(
              children: [
                Text.rich(
                  TextSpan(
                    text: '',
                    children: _getFlashSaleProgressLabelTexts(
                      context,
                      flashSaleEndsIn,
                    ),
                  ),
                  maxLines: 2,
                  style: Theme.of(context).textTheme.caption,
                  overflow: TextOverflow.fade,
                ),
                const SizedBox(
                  height: 4,
                ),
                AvailableProgressBar(
                  remainingDurationInHours: flashSaleEndsIn.inHours.roundToDouble(),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
        error: (err, stack) {
          loggy.error('Failed to fetch flash sale end', err, stack);
          return const SizedBox.shrink();
        },
        orElse: () => const SizedBox.shrink());
  }

  List<TextSpan> _getFlashSaleProgressLabelTexts(BuildContext context, Duration flashSaleEndsIn) {
    const highlightStyle = TextStyle(fontWeight: FontWeight.bold);

    if (flashSaleEndsIn.inSeconds <= 0) {
      return [TextSpan(text: context.l10n.flashSaleEnded)];
    }
    if (flashSaleEndsIn.inDays >= 1) {
      return [
        TextSpan(text: '${context.l10n.remainingDays}: '),
        TextSpan(
          text: flashSaleEndsIn.inDays.toString(),
          style: highlightStyle,
        ),
      ];
    }
    if (flashSaleEndsIn.inHours >= 1) {
      return [
        TextSpan(text: '${context.l10n.remainingHours}: '),
        TextSpan(
          text: flashSaleEndsIn.inHours.toString(),
          style: highlightStyle,
        ),
      ];
    }
    return [
      TextSpan(text: '${context.l10n.remainingMinutes}: '),
      TextSpan(
        text: flashSaleEndsIn.inMinutes.toString(),
        style: highlightStyle,
      ),
    ];
  }
}
