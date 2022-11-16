import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/empty_tab.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/features/cart/presentation/providers/providers.dart';
import 'package:delivery/src/features/checkout/data/models/payment_data.dart';
import 'package:delivery/src/features/checkout/presentation/providers/providers.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/credit_cards.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/native_payments.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/pay_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger((PaymentMethodView).toString());

class PaymentMethodView extends HookConsumerWidget {
  final PaymentData paymentData;

  final void Function() onBackButton;
  final void Function(String checkoutDoneMsg) onCheckoutDone;

  const PaymentMethodView(
    this.paymentData, {
    Key? key,
    required this.onBackButton,
    required this.onCheckoutDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartData = ref.watch(cartProvider);
    final scrollController = useScrollController();

    return Loader(
      inAsyncCall: ref.watch(
        checkoutStateProvider.select((value) => value.isLoading),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: onBackButton,
          ),
          title: Text(
            context.l10n.checkout,
          ),
        ),
        body: CupertinoScrollbar(
          controller: scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: cartData.when(
              data: (cart) => cart == null
                  ? EmptyTab(
                      icon: Icons.info_outline,
                      message: context.l10n.youHaveAnEmptyCart,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                            title: Text(
                              context.l10n.selectYourPreferredPaymentMode,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.subtitle1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const CreditCards(),
                        const SizedBox(height: 40),
                        PayButton(
                          paymentData: paymentData,
                          value: cart.totalCartValue,
                          onCheckoutDone: onCheckoutDone,
                        ),
                        const SizedBox(height: 20),
                        NativePayments(
                          paymentData: paymentData,
                          value: cart.totalCartValue,
                          onCheckoutDone: onCheckoutDone,
                        ),
                      ],
                    ),
              loading: () => const Loader(),
              error: (err, stack) {
                _logger.severe('Failed to fetch cart data', err, stack);
                return Center(
                  child: Text(context.l10n.error),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
