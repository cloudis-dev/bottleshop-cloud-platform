import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/features/cart/presentation/providers/providers.dart';
import 'package:delivery/src/features/checkout/presentation/providers/providers.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/additional_remarks_tile.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/promo_code_tile.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/templates/cart_view_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RemainingDetailsView extends HookConsumerWidget {
  final Future<void> Function() onNextPage;
  final void Function() onBackButton;

  const RemainingDetailsView({
    Key? key,
    required this.onNextPage,
    required this.onBackButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollCtrl = useScrollController();

    return ref.watch(cartProvider).when(
          data: (cart) => Loader(
            inAsyncCall: ref.watch(isRedirectingProvider),
            child: CheckoutViewTemplate(
              contentBuilder: (_) => CupertinoScrollbar(
                controller: scrollCtrl,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollCtrl,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const AdditionalRemarksTile(),
                      PromoCodeTile(cart: cart),
                    ],
                  ),
                ),
              ),
              actionCallback: (_) => onNextPage,
              pageTitle: context.l10n.furtherDetails,
              actionButtonText:
                  (ref.read(orderTypeStateProvider)?.isPaymentRequired ?? false)
                      ? context.l10n.proceedToCheckOutWithANeedToPay
                      : context.l10n.confirmOrderPayLater,
              onBackButton: onBackButton,
            ),
          ),
          loading: () => const Loader(),
          error: (err, stack) {
            return Center(
              child: Text(context.l10n.error),
            );
          },
        );
  }
}
