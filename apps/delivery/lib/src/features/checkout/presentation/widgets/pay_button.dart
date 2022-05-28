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
import 'package:delivery/src/features/checkout/data/models/payment_data.dart';
import 'package:delivery/src/features/checkout/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:loggy/loggy.dart';

class PayButton extends HookConsumerWidget with NetworkLoggy {
  final PaymentData paymentData;
  final double value;
  final void Function(String checkoutDoneMsg) onCheckoutDone;

  const PayButton({
    Key? key,
    required this.paymentData,
    required this.value,
    required this.onCheckoutDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      fit: StackFit.loose,
      alignment: AlignmentDirectional.centerEnd,
      children: <Widget>[
        SizedBox(
          width: 208,
          height: 45,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                primary: Theme.of(context).colorScheme.onBackground,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: const RoundedRectangleBorder()),
            onPressed: () async {
              try {
                await ref.read(checkoutStateProvider).payByCreditCard(paymentData).then(
                  (value) async {
                    await logPurchase(ref, context, this.value);

                    onCheckoutDone(context.l10n.successful_payment_card);
                  },
                );
              } on PlatformException catch (err, stack) {
                if (err.code != 'cancelled' || err.code != 'purchaseCancelled') {
                  rethrow;
                } else {
                  loggy.error('Failed to pay by credit card', err, stack);

                  showSimpleNotification(
                    Text(context.l10n.errorGeneric),
                    position: NotificationPosition.bottom,
                    context: context,
                  );
                }
              } catch (err, stack) {
                loggy.error('Failed to pay by credit card', err, stack);

                showSimpleNotification(
                  Text(context.l10n.errorGeneric),
                  position: NotificationPosition.bottom,
                  context: context,
                );
              }
            },
            icon: const Icon(Icons.account_balance_outlined),
            label: Text(
              context.l10n.confirmPayment,
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }

  logPurchase(WidgetRef ref, BuildContext context, double value) {}
}
