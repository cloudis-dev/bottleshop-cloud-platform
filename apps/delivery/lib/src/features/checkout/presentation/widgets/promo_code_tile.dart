import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/cart/data/models/cart_model.dart';
import 'package:delivery/src/features/checkout/data/services/promo_codes_service.dart';
import 'package:delivery/src/features/checkout/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:delivery/src/core/data/services/analytics_service.dart';

class PromoCodeTile extends HookConsumerWidget {
  final CartModel cart;

  const PromoCodeTile({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promoCode = ref.watch(currentAppliedPromoProvider);
    final textCtrl = useTextEditingController(text: promoCode?.code);
    final orderType = ref.watch(orderTypeStateProvider);

    return Card(
      color: Theme.of(context).primaryColor,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: ExpansionTile(
        initiallyExpanded: promoCode != null,
        title: Text(
          context.l10n.promoCodeLabel,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        subtitle: Text(
          context.l10n.promoCodeInstructions,
          style: Theme.of(context).textTheme.caption,
        ),
        leading: const Icon(
          Icons.discount,
        ),
        children: [
          ListTile(
            title: TextField(
              controller: textCtrl,
            ),
            trailing: promoCode == null
                ? OutlinedButton(
                    onPressed: () async {
                      final promo =
                          await promoCodeDbService.getSingle(textCtrl.text);

                      if (promo == null) {
                        showSimpleNotification(
                          Text(context.l10n.promoCodeInvalid),
                          duration: const Duration(seconds: 5),
                          slideDismissDirection: DismissDirection.horizontal,
                          context: context,
                        );
                      } else {
                        if (promo.isPromoValid(cart, orderType)) {
                          ref.read(currentAppliedPromoProvider.state).state =
                              promo;                 
                          logUsePromo(ref, promo.code, promo.promoCodeType, promoCode!.discount);
                          showSimpleNotification(
                            Text(context.l10n.promoCodeApplied),
                            duration: const Duration(seconds: 5),
                            slideDismissDirection: DismissDirection.horizontal,
                            context: context,
                          );
                        } else {
                          showSimpleNotification(
                            Text(context.l10n.promoCodeInvalid),
                            duration: const Duration(seconds: 5),
                            slideDismissDirection: DismissDirection.horizontal,
                            context: context,
                          );
                        }
                      }
                    },
                    child: Text(context.l10n.applyPromoCode),
                  )
                : ElevatedButton(
                    onPressed: () {
                      ref.read(currentAppliedPromoProvider.state).state = null;

                      showSimpleNotification(
                        Text(context.l10n.promoCodeRemoved),
                        duration: const Duration(seconds: 5),
                        slideDismissDirection: DismissDirection.horizontal,
                        context: context,
                      );
                    },
                    child: Text(context.l10n.removePromoCode),
                  ),
          ),
        ],
      ),
    );
  }
}
