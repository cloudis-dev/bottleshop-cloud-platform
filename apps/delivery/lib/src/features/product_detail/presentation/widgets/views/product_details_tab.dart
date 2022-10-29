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
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/features/product_detail/presentation/widgets/atoms/detail_row_item.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductDetailsTab extends HookConsumerWidget {
  final ProductModel product;

  const ProductDetailsTab({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(currentLocaleProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          title: Text(
            context.l10n.details,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailRowItem(
                title: context.l10n.alcoholContent,
                value: FormattingUtils.getAlcoholNumberString(
                    product.alcohol ?? 0),
              ),
              DetailRowItem(
                title: context.l10n.volume,
                value:
                    '${FormattingUtils.getVolumeNumberString(product.unitsCount)} ${product.unitsType.getUnitAbbreviation(currentLocale)}',
              ),
              if (product.isFlashSale)
                Row(
                  children: [
                    Icon(
                      Icons.alarm_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Text(
                        context.l10n.flashSales,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              if (product.isNewEntry)
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Text(
                        context.l10n.newAdditionToOurStock,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              if (product.isRecommended)
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Text(
                        context.l10n.recommendedByOurStaff,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10.0),
              if (product.isFlashSale)
                DetailRowItem(
                  title: context.l10n.flashsaleUntil,
                  value: FormattingUtils.getDateTimeFormatter(currentLocale)
                      .format(product.flashSale!.flashSaleUntil),
                ),
              if (product.isSpecialEdition)
                DetailRowItem(
                  title: context.l10n.specialEdition,
                  value: product.edition,
                ),
              if (product.age != null)
                DetailRowItem(
                  title: context.l10n.age,
                  value: product.age.toString(),
                ),
              if (product.year != null)
                DetailRowItem(
                  title: context.l10n.year,
                  value: product.year.toString(),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      context.l10n.country,
                      style: Theme.of(context).textTheme.subtitle2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        product.country.getName(currentLocale)!,
                        style: Theme.of(context).textTheme.subtitle2,
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 20.0,
                        width: 40.0,
                        child: SvgPicture.network(
                          product.country.flagUrl!,
                          placeholderBuilder: (_) => Container(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
