import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/features/checkout/presentation/providers/providers.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/additional_remarks_tile.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/checkout_tile.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/promo_code_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger((RemainingDetailsView).toString());

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

    return Loader(
      inAsyncCall: ref.watch(isRedirectingProvider),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.furtherDetails),
          leading: BackButton(onPressed: onBackButton),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 120),
              padding: const EdgeInsets.only(bottom: 30),
              child: CupertinoScrollbar(
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
                    children: const <Widget>[
                      AdditionalRemarksTile(),
                      PromoCodeTile(),
                    ],
                  ),
                ),
              ),
            ),
            CheckoutTile(
              showShipping: true,
              actionLabel: context.l10n.proceedToCheckout,
              actionCallback: onNextPage,
            ),
          ],
        ),
      ),
    );
  }
}
