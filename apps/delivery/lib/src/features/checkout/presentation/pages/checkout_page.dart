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
import 'package:delivery/src/core/data/services/cloud_functions_service.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/checkout/data/models/payment_data.dart';
import 'package:delivery/src/features/checkout/data/models/stripe_session_request.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/views/checkout_done_view.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/views/payment_method_view.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/views/shipping_details_view.dart';
import 'package:delivery/src/features/home/presentation/widgets/page_body_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:overlay_support/overlay_support.dart';

class CheckoutPage extends HookConsumerWidget with UiLoggy {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final currentLocale = ref.watch(currentLocaleProvider);
    final paymentDataNotifier = useValueNotifier<PaymentData?>(null, const []);
    final checkoutDoneMessageNotifier = useValueNotifier<String?>(null, const []);

    final pageCtrl = usePageController(keys: const []);

    final content = PageView(
      controller: pageCtrl,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ShippingDetailsView(
          onNextPage: (paymentData) async {
            loggy.info('payment data: ${paymentData.toString()}');
            paymentDataNotifier.value = paymentData;
            if (kIsWeb) {
              if (paymentData.deliveryType == kOrderTypeCashOnDelivery) {
                final orderId = await ref.read(cloudFunctionsProvider).createCashOnDeliveryOrder(paymentData);
                loggy.info('orderID: $orderId');
                if (orderId != null) {
                  checkoutDoneMessageNotifier.value = 'Order #$orderId confirmed';
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
                final sessionId = await ref.read(cloudFunctionsProvider).createStripePriceIds(sessionRequest);

              }
            } else {
              await pageCtrl.animateToPage(
                1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }
          },
          onBackButton: () {},
        ),
        ValueListenableBuilder<PaymentData?>(
          valueListenable: paymentDataNotifier,
          builder: (context, paymentData, _) => paymentData == null
              ? const SizedBox.shrink()
              : PaymentMethodView(
                  paymentData: paymentData,
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
          builder: (context, checkoutDoneMessage, _) => checkoutDoneMessage == null
              ? const SizedBox.shrink()
              : CheckoutDoneView(
                  checkoutDoneMessage,
                  onClose: () {},
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
