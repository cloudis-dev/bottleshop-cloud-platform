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
import 'package:delivery/src/core/data/res/app_environment.dart';
import 'package:delivery/src/core/data/services/analytics_service.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/checkout/data/models/payment_data.dart';
import 'package:delivery/src/features/checkout/presentation/pages/stripe_checkout_failure.dart';
import 'package:delivery/src/features/checkout/presentation/pages/stripe_checkout_success.dart';
import 'package:delivery/src/features/checkout/presentation/providers/providers.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/views/remaining_details_view.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/views/shipping_details_view.dart';
import 'package:delivery/src/features/home/presentation/pages/home_page.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/page_body_template.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:routeborn/routeborn.dart';
import 'package:stripe_checkout/stripe_checkout.dart';

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

class _CheckoutPageView extends HookConsumerWidget {
  const _CheckoutPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This is to not dispose the state
    ref.watch(orderTypeStateProvider);
    ref.watch(currentAppliedPromoProvider);
    ref.watch(remarksTextEditCtrlProvider);

    final pageCtrl = usePageController(keys: const []);

    final content = PageView(
      controller: pageCtrl,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ShippingDetailsView(
          onNextPage: () => pageCtrl.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          ),
          onBackButton: () {
            ref.read(navigationProvider).popPage(context);
          },
        ),
        RemainingDetailsView(
          onNextPage: () async {
            ref.read(isRedirectingProvider.state).state = true;
            await getCheckout(context, ref);
            ref.read(isRedirectingProvider.state).state = false;
          },
          onBackButton: () => pageCtrl.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          ),
        ),
      ],
    );

    if (shouldUseMobileLayout(context)) {
      return content;
    } else {
      return PageBodyTemplate(child: content);
    }
  }

  Future<void> getCheckout(BuildContext context, WidgetRef ref) async {
    final deliveryOption = ref.read(orderTypeStateProvider)?.deliveryOption;

    if (deliveryOption == null) {
      showSimpleNotification(
        Text(context.l10n.errorGeneric),
        position: NotificationPosition.top,
        duration: const Duration(seconds: 3),
        slideDismissDirection: DismissDirection.horizontal,
        context: context,
      );
      return;
    }

    final successUrl =
        "${Uri.base.origin}/${HomePage.pagePathBase}/${StripeCheckoutSuccessPage.pagePathBase}";
    final cancelUrl =
        "${Uri.base.origin}/${HomePage.pagePathBase}/${StripeCheckoutFailurePage.pagePathBase}";

    final orderNote = ref.read(remarksTextEditCtrlProvider).text;
    final promo = ref.read(currentAppliedPromoProvider)?.code;
    final language = ref.watch(currentLanguageProvider);

    final paymentData = PaymentData(
      successUrl: successUrl,
      cancelUrl: cancelUrl,
      deliveryType: deliveryOption.toString(),
      orderNote: orderNote,
      platformType: kIsWeb ? PlatformType.web : PlatformType.mobile,
      promoCode: promo,
      locale: language.name,
    );

    switch (deliveryOption) {
      case DeliveryOption.cashOnDelivery:
        try {
          await ref
              .read(cloudFunctionsProvider)
              .createCashOnDeliveryOrder(paymentData);

          if (context.mounted) {
            ref.read(navigationProvider).setNestingBranch(
                  context,
                  NestingBranch.success,
                );
          }
         await logPaymentMethod(ref,  DeliveryOption.cashOnDelivery.toString());
          
        } catch (err, stack) {
          _logger.severe('Failed to create cash-on-delivery order', err, stack);
          showSimpleNotification(
            Text(context.l10n.errorGeneric),
            position: NotificationPosition.top,
            duration: const Duration(seconds: 3),
            slideDismissDirection: DismissDirection.horizontal,
            context: context,
          );
        }
        break;
      default:
        if (kIsWeb) {
          await logPaymentMethod(ref,  deliveryOption.toString());
          final sessionId = await ref
              .read(cloudFunctionsProvider)
              .createCheckoutSession(paymentData);

          if (sessionId == null) {
            if (context.mounted) {
              showSimpleNotification(
                Text(context.l10n.errorGeneric),
                position: NotificationPosition.top,
                duration: const Duration(seconds: 3),
                slideDismissDirection: DismissDirection.horizontal,
                context: context,
              );
            }
            await logPaymentMethod(ref, deliveryOption.toString());
          } else {
            if (context.mounted) {
              (await redirectToCheckout(
                context: context,
                sessionId: sessionId,
                publishableKey: AppEnvironment.stripePublishableKey,
                successUrl: successUrl,
                canceledUrl: cancelUrl,
              ))
                  .maybeWhen(
                error: (err) => _logger.severe(err),
                orElse: () {},
              );
            }
          }
        } else {
          throw UnimplementedError(
              "Payments not yet implemented for mobile platform");
        }
    }
  }
}
