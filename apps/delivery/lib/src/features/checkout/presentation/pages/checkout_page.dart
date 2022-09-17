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

import 'package:dartz/dartz.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/checkout/data/models/payment_data.dart';
import 'package:delivery/src/features/checkout/data/models/stripe_session_request.dart';
import 'package:delivery/src/features/checkout/presentation/pages/stripe_checkout.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/views/checkout_done_view.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/views/payment_method_view.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/views/shipping_details_view.dart';
import 'package:delivery/src/features/home/presentation/pages/home_page.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/page_body_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:routeborn/routeborn.dart';

final _logger = Logger((CheckoutPage).toString());

class CheckoutPage extends RoutebornPage {
  static const String pagePathBase = 'checkout';

  CheckoutPage()
      : super.builder(pagePathBase, (_) => const _CheckoutPageView());

  @override
  Either<ValueListenable<String?>, String> getPageName(BuildContext context) =>
      const Right('TODO');

  @override
  String getPagePath() => pagePathBase;

  @override
  String getPagePathBase() => pagePathBase;
}

class _CheckoutPageView extends HookWidget {
  const _CheckoutPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = useProvider(currentUserProvider);
    final currentLocale = useProvider(currentLocaleProvider);
    final paymentDataNotifier = useValueNotifier<PaymentData?>(null, const []);
    final checkoutDoneMessageNotifier =
        useValueNotifier<String?>(null, const []);

    final pageCtrl = usePageController(keys: const []);

    final content = PageView(
      controller: pageCtrl,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Loader(
          inAsyncCall: useProvider(isRedirectingProvider),
          child: ShippingDetailsView(
            onNextPage: (paymentData) async {
              _logger.info('payment data: ${paymentData.toString()}');
              paymentDataNotifier.value = paymentData;
              if (kIsWeb) {
                context.read(isRedirectingProvider.notifier).redirecting = true;
                if (paymentData.deliveryType == kOrderTypeCashOnDelivery) {
                  final orderId = await context
                      .read(cloudFunctionsProvider)
                      .createCashOnDeliveryOrder(paymentData);
                  _logger.info('orderID: $orderId');
                  context.read(isRedirectingProvider.notifier).redirecting =
                      false;
                  if (orderId != null) {
                    checkoutDoneMessageNotifier.value =
                        'Order #$orderId confirmed';

                    showSimpleNotification(
                      Text(context.l10n.thankYouForYourOrder),
                      position: NotificationPosition.bottom,
                      context: context,
                    );

                    await pageCtrl.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    showSimpleNotification(
                      Text(context.l10n.error),
                      position: NotificationPosition.bottom,
                      context: context,
                    );
                  }
                } else {
                  final sessionRequest = StripeSessionRequest(
                    userId: currentUser!.uid,
                    domain: Uri.base.origin,
                    locale: currentLocale.languageCode,
                    deliveryType: paymentData.deliveryType,
                    orderNote: paymentData.orderNote,
                  );
                  final sessionId = await context
                      .read(cloudFunctionsProvider)
                      .createStripePriceIds(sessionRequest);
                  _logger.info('sessionID: $sessionId');
                  await redirectToCheckout(sessionId);
                }
              } else {
                await pageCtrl.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
            },
            onBackButton: () {
              context.read(navigationProvider).popPage(context);
            },
          ),
        ),
        ValueListenableBuilder<PaymentData?>(
          valueListenable: paymentDataNotifier,
          builder: (context, paymentData, _) => paymentData == null
              ? const SizedBox.shrink()
              : PaymentMethodView(
                  paymentData,
                  onBackButton: () {
                    pageCtrl.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  onCheckoutDone: (checkoutDoneMsg) {
                    checkoutDoneMessageNotifier.value = checkoutDoneMsg;

                    showSimpleNotification(
                      Text(context.l10n.thankYouForYourOrder),
                      position: NotificationPosition.bottom,
                      context: context,
                    );

                    pageCtrl.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                ),
        ),
        ValueListenableBuilder<String?>(
          valueListenable: checkoutDoneMessageNotifier,
          builder: (context, checkoutDoneMessage, _) => checkoutDoneMessage ==
                  null
              ? const SizedBox.shrink()
              : CheckoutDoneView(
                  checkoutDoneMessage,
                  onClose: () {
                    context
                        .read(navigationProvider)
                        .replaceRootStackWith([AppPageNode(page: HomePage())]);
                  },
                ),
        )
      ],
    );

    if (shouldUseMobileLayout(context)) {
      return content;
    } else {
      return PageBodyTemplate(child: content);
    }
  }
}

class RedirectToStripeState extends StateNotifier<bool> {
  set redirecting(bool redirecting) => state = redirecting;

  bool get redirecting => state;

  RedirectToStripeState() : super(false);
}

final isRedirectingProvider =
    StateNotifierProvider.autoDispose<RedirectToStripeState, bool>(
  (ref) => RedirectToStripeState(),
);
