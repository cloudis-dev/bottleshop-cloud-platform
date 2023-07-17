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

import 'dart:async';

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/presentation/widgets/progress_button.dart';
import 'package:delivery/src/core/utils/app_config.dart';
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/features/cart/presentation/providers/providers.dart';
import 'package:delivery/src/features/checkout/presentation/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../../../cart/data/models/cart_model.dart';
import '../../../cart/data/models/promo_code_model.dart';
import '../../../orders/data/models/order_type_model.dart';

class CheckoutTile extends HookConsumerWidget {
  final String actionLabel;
  final Future<void> Function()? actionCallback;
  final bool isLastStep;

  const CheckoutTile({
    Key? key,
    this.isLastStep = false,
    required this.actionLabel,
    required this.actionCallback,
  }) : super(key: key);

  double calculatePromoDiscount(
      OrderTypeModel orderType, PromoCodeModel promoCode, CartModel cart) {
    return (promoCode?.promoCodeType == 'percent'
        ? promoCode!.discount / 100 * cart.totalProductsPrice
        : (promoCode?.discount ?? 0));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promoCode = ref.watch(currentAppliedPromoProvider);
    final orderType = ref.watch(orderTypeStateProvider);
    final currentLang = ref.watch(currentLanguageProvider);

    return ref.watch(cartProvider).when(
          data: (cart) {
            final subtotal = cart.totalProductsPriceNoVat +
                (orderType?.shippingFeeNoVat ?? 0) -
                calculatePromoDiscount(orderType!, promoCode!, cart);
            final totalVat = cart.totalProductsVat + (orderType?.feeVat ?? 0);
            final totalValue = cart.totalProductsPrice +
                (orderType?.feeWithVat ?? 0) -
                calculatePromoDiscount(orderType!, promoCode!, cart);
            return Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                      offset: const Offset(0, -2),
                      blurRadius: 5.0)
                ],
              ),
              child: SizedBox(
                width: AppConfig(context).appWidth(90),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(context.l10n.cart,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          Text(
                            FormattingUtils.getPriceNumberString(
                              cart.totalProductsPrice,
                              withCurrency: true,
                            ),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                      if (orderType != null && orderType.isPaymentRequired)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                  "${context.l10n.shippingFee}: ${orderType.getName(currentLang)}",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ),
                            Text(
                              FormattingUtils.getPriceNumberString(
                                orderType.feeWithVat,
                                withCurrency: true,
                              ),
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      if (promoCode != null)
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                  "${context.l10n.promoCodeLabel}: ${promoCode.code}",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ),
                            Text(
                              '- ${FormattingUtils.getPriceNumberString(
                                (promoCode?.promoCodeType == 'percent'
                                    ? promoCode!.discount /
                                        100 *
                                        cart.totalProductsPrice
                                    : (promoCode?.discount ?? 0)),
                                withCurrency: true,
                              )}',
                              style: Theme.of(context).textTheme.subtitle1,
                            )
                          ],
                        ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(context.l10n.subtotal,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          Text(
                              FormattingUtils.getPriceNumberString(
                                subtotal,
                                withCurrency: true,
                              ),
                              style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(context.l10n.vat20,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          Text(
                            FormattingUtils.getPriceNumberString(
                              totalVat,
                              withCurrency: true,
                            ),
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                        ],
                      ),
                      const Spacer(flex: 1),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(context.l10n.checkout,
                                  style:
                                      Theme.of(context).textTheme.headline6)),
                          Text(
                            FormattingUtils.getPriceNumberString(
                              totalValue,
                              withCurrency: true,
                            ),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                      const Spacer(flex: 1),
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              fit: StackFit.loose,
                              alignment: AlignmentDirectional.centerEnd,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  child: ProgressButton(
                                    maxWidth: double.infinity,
                                    minWidth: double.infinity,
                                    onPressed: actionCallback,
                                    state: ButtonState.idle,
                                    stateWidgets: {
                                      ButtonState.idle: Text(
                                        actionLabel,
                                        textAlign: TextAlign.start,
                                      ),
                                      ButtonState.loading: const Loader(),
                                      ButtonState.success:
                                          const SizedBox.shrink(),
                                      ButtonState.fail: const SizedBox.shrink(),
                                    },
                                    stateColors: {
                                      for (var e in ButtonState.values.map(
                                          (e) => Tuple2(
                                              e,
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary)))
                                        e.item1: e.item2
                                    },
                                  ),
                                ),
                                if (!isLastStep)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const Loader(),
          error: (_, __) => Center(child: Text(context.l10n.error)),
        );
  }

  void onPrimaryButtonClick(BuildContext context, WidgetRef ref) =>
      actionCallback!;
}
