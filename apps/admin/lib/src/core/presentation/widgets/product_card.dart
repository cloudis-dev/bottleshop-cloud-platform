import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/chips/products/discount_chip.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/chips/products/flash_sale_chip.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/chips/products/in_stock_chip.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/chips/products/new_entry_chip.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/chips/products/recommended_chip.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/details_column.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/price_row.dart';
import 'package:bottleshop_admin/src/core/utils/formatting_util.dart';
import 'package:bottleshop_admin/src/features/products/data/models/product_model.dart';
import 'package:bottleshop_admin/src/features/products/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/products/presentation/widgets/descriptions_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductCard extends HookWidget {
  static const double thumbnailWidth = 64;

  final ProductModel product;
  final WidgetBuilder productCardMenuButtonBuilder;

  const ProductCard({
    Key? key,
    required this.product,
    required this.productCardMenuButtonBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black.withOpacity(.3), width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                useProvider(productThumbnailImgProvider(product)).when(
                  data: (imgUrl) => Image.network(
                    imgUrl,
                    width: thumbnailWidth,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        width: thumbnailWidth,
                        height: thumbnailWidth,
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                  loading: () => const SizedBox(
                    width: thumbnailWidth,
                    height: thumbnailWidth,
                    child: CircularProgressIndicator(),
                  ),
                  error: (_, __) => Image.asset(
                    'assets/images/placeholder.png',
                    width: thumbnailWidth,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailsColumn(
                          product: product,
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ),
                productCardMenuButtonBuilder(context),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DescriptionsPanel(
                  descriptionSk: product.descriptionSk,
                  descriptionEn: product.descriptionEn,
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 4,
                  runSpacing: 4,
                  children: <Widget>[
                    InStockChip(product.count),
                    if (product.hasDiscount)
                      DiscountChip(discount: product.discount),
                    if (product.isFlashSale) const FlashSaleChip(),
                    if (product.isRecommended) const RecommendedChip(),
                    if (product.isNewEntry) const NewEntryChip(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: PriceRow(
                    title: 'Cena bez DPH',
                    priceString:
                        FormattingUtil.getPriceString(product.priceNoVat),
                    textStyle: AppTheme.subtitle1TextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: PriceRow(
                    title: 'Cena s DPH',
                    priceString: FormattingUtil.getPriceString(
                        product.priceWithVatWithoutDiscount),
                    textStyle: AppTheme.subtitle1TextStyle,
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 16),
                  child: PriceRow(
                    title: 'Cena s DPH po zľave',
                    textStyle: AppTheme.headline2TextStyle,
                    priceString: FormattingUtil.getPriceString(
                        product.finalPriceWithVat),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
