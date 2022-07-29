import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:bottleshop_admin/features/products/presentation/providers.dart';
import 'package:bottleshop_admin/models/order_model.dart';
import 'package:bottleshop_admin/ui/shared_widgets/details_column.dart';
import 'package:bottleshop_admin/ui/shared_widgets/price_row.dart';
import 'package:bottleshop_admin/utils/discount_util.dart';
import 'package:bottleshop_admin/utils/formatting_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CartItemWidget extends HookWidget {
  static const double thumbnailWidth = 64;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
    required this.id,
    required this.totalCount,
  }) : super(key: key);

  final CartItemModel cartItem;
  final int id;
  final int totalCount;

  @override
  Widget build(BuildContext context) => Container(
        color: id % 2 == 0 ? AppTheme.lightOrangeSolid : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  useProvider(productThumbnailImgProvider(cartItem.product))
                      .when(
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
                    child: Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${id + 1} / $totalCount',
                            style: AppTheme.overlineTextStyle,
                          ),
                          DetailsColumn(
                            product: cartItem.product,
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Spacer(),
                      Expanded(
                        flex: 3,
                        child: Text(
                          '${cartItem.count}ks',
                          style: AppTheme.headline1TextStyle,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (cartItem.product.hasDiscount)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: PriceRow(
                      title: 'Zľava:',
                      priceString:
                          '${DiscountUtil.getPercentageFromDiscount(cartItem.product.discount!)}%',
                      textStyle: AppTheme.subtitle1TextStyle,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: PriceRow(
                    title: 'Cena bez DPH 1ks:',
                    priceString: FormattingUtil.getPriceString(
                        cartItem.product.finalPriceNoVat),
                    textStyle: AppTheme.subtitle1TextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: PriceRow(
                    title: 'Cena s DPH 1ks:',
                    priceString: FormattingUtil.getPriceString(
                        cartItem.product.finalPriceWithVat),
                    textStyle: AppTheme.subtitle1TextStyle,
                  ),
                ),
              ],
            ),
            const Divider(),
            PriceRow(
              title: 'Zaplatená cena za ${cartItem.count}ks:',
              priceString: FormattingUtil.getPriceString(cartItem.paidPrice),
              textStyle: AppTheme.headline2TextStyle,
            ),
          ],
        ),
      );
}
