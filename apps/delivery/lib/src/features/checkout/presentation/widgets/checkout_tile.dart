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

import 'package:delivery/generated/l10n.dart';
import 'package:delivery/src/core/data/services/cloud_functions_service.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/widgets/adaptive_alert_dialog.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/presentation/widgets/progress_button.dart';
import 'package:delivery/src/core/presentation/widgets/styled_form_field.dart';
import 'package:delivery/src/core/utils/app_config.dart';
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/features/cart/presentation/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tuple/tuple.dart';

final _proceedButtonStateProvider = StateProvider.autoDispose
    .family<ButtonState, String>((ref, _) => ButtonState.idle);

final _promoButtonStateProvider =
    StateProvider.autoDispose<ButtonState>((ref) => ButtonState.idle);

class CheckoutTile extends HookWidget {
  final String actionLabel;
  final VoidCallback? actionCallback;
  final bool isLastStep;
  final bool showShipping;

  final bool showPromoButton;
  const CheckoutTile({
    Key? key,
    this.showShipping = false,
    this.isLastStep = false,
    this.showPromoButton = false,
    required this.actionLabel,
    required this.actionCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final promoCodeTextController = useTextEditingController();

    return useProvider(cartProvider).when(
      data: (cart) {
        return Positioned(
          bottom: MediaQuery.of(context).padding.bottom,
          left: 0,
          right: 0,
          child: Container(
            height: 170,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                      offset: const Offset(0, -2),
                      blurRadius: 5.0)
                ]),
            child: SizedBox(
              width: AppConfig(context).appWidth(90),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                      child: Text(S.of(context).subtotal,
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Text(
                        FormattingUtils.getPriceNumberString(
                          cart!.subTotal,
                          withCurrency: true,
                        ),
                        style: Theme.of(context).textTheme.subtitle1),
                  ]),
                  Row(children: <Widget>[
                    Expanded(
                      child: Text(S.of(context).vat20,
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Text(
                        FormattingUtils.getPriceNumberString(
                          cart.totalCartVat,
                          withCurrency: true,
                        ),
                        style: Theme.of(context).textTheme.subtitle1)
                  ]),
                  if (cart.promoCode != null)
                    Row(children: <Widget>[
                      Expanded(
                        child: Text(S.of(context).promoCodeLabel,
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                      Text(
                          '- ${FormattingUtils.getPriceNumberString(
                            cart.promoCodeValue,
                            withCurrency: true,
                          )}',
                          style: Theme.of(context).textTheme.subtitle1)
                    ]),
                  const Spacer(flex: 1),
                  Row(children: <Widget>[
                    Expanded(
                        child: Text(S.of(context).checkout,
                            style: Theme.of(context).textTheme.headline6)),
                    Text(
                      FormattingUtils.getPriceNumberString(
                        cart.totalCartValue,
                        withCurrency: true,
                      ),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ]),
                  const Spacer(flex: 1),
                  Row(
                    children: [
                      if (showPromoButton)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0) +
                              const EdgeInsets.only(right: 12),
                          child: ProgressButton(
                            onPressed: () async {
                              try {
                                if (cart.promoCode != null) {
                                  context.read(_promoButtonStateProvider);
                                  var res = await context
                                      .read(cloudFunctionsProvider)
                                      .removePromoCode();
                                  if (res) {
                                    showSimpleNotification(
                                      Text(S.of(context).promoCodeRemoved),
                                      duration: const Duration(seconds: 5),
                                      slideDismissDirection:
                                          DismissDirection.horizontal,
                                      context: context,
                                    );
                                  }
                                } else {
                                  var promo = await showAddPromoDialog(
                                      context, promoCodeTextController);
                                  context
                                      .read(_promoButtonStateProvider)
                                      .state = ButtonState.loading;
                                  if (promo != null || promo!.isNotEmpty) {
                                    final res = await context
                                        .read(cartRepositoryProvider)!
                                        .promoApplied(promo);
                                    if (res) {
                                      showSimpleNotification(
                                        Text(S.of(context).promoCodeApplied),
                                        duration: const Duration(seconds: 5),
                                        slideDismissDirection:
                                            DismissDirection.horizontal,
                                        context: context,
                                      );
                                    } else {
                                      showSimpleNotification(
                                        Text(S.of(context).promoCodeInvalid),
                                        duration: const Duration(seconds: 5),
                                        slideDismissDirection:
                                            DismissDirection.horizontal,
                                        context: context,
                                      );
                                    }
                                  }
                                }
                              } finally {
                                context.read(_promoButtonStateProvider).state =
                                    ButtonState.idle;
                              }
                            },
                            minWidth: AppConfig(context).appWidth(20),
                            maxWidth: AppConfig(context).appWidth(20),
                            state: useProvider(
                              _promoButtonStateProvider
                                  .select((value) => value.state),
                            ),
                            stateWidgets: {
                              ButtonState.idle: InkResponse(
                                splashColor:
                                    Colors.deepOrangeAccent, // splash color
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    cart.promoCode == null
                                        ? Text(S.of(context).promoCodeLabel)
                                        : Icon(
                                            Icons.receipt_long_outlined,
                                            color: cart.promoCode != null
                                                ? Colors.white
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                          ), // icon
                                    // text
                                  ],
                                ),
                              ),
                              ButtonState.loading: Loader(
                                  valueColor: Theme.of(context).primaryColor),
                              ButtonState.success: const SizedBox.shrink(),
                              ButtonState.fail: const SizedBox.shrink(),
                            },
                            stateColors: {
                              for (var e in ButtonState.values.map((e) =>
                                  Tuple2(e, Theme.of(context).primaryColor)))
                                e.item1: e.item2
                            },
                          ),
                        ),
                      Expanded(
                        child: Stack(
                          fit: StackFit.loose,
                          alignment: AlignmentDirectional.centerEnd,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: ProgressButton(
                                maxWidth: double.infinity,
                                minWidth: double.infinity,
                                onPressed: actionCallback == null
                                    ? null
                                    : () => onPrimaryButtonClick(context),
                                state: useProvider(
                                    _proceedButtonStateProvider(actionLabel)
                                        .select((value) => value.state)),
                                stateWidgets: {
                                  ButtonState.idle: Text(
                                    actionLabel,
                                    textAlign: TextAlign.start,
                                  ),
                                  ButtonState.loading: const Loader(),
                                  ButtonState.success: const SizedBox.shrink(),
                                  ButtonState.fail: const SizedBox.shrink(),
                                },
                                stateColors: {
                                  for (var e in ButtonState.values.map((e) =>
                                      Tuple2(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
      error: (_, __) => Center(child: Text(S.of(context).error)),
    );
  }

  void onPrimaryButtonClick(BuildContext context) async {
    try {
      context.read(_proceedButtonStateProvider(actionLabel)).state =
          ButtonState.loading;

      final res = await context.read(cloudFunctionsProvider).validateCart();
      switch (res) {
        case CartStatus.ok:
          actionCallback!();
          break;
        case CartStatus.unavailableProducts:
          showSimpleNotification(
            Text(S.of(context).theCartContainsItemCountsThatAreNotAvailableIn),
            duration: const Duration(seconds: 5),
            slideDismissDirection: DismissDirection.horizontal,
            context: context,
          );
          break;
        case CartStatus.invalidPromo:
          showSimpleNotification(
            Text(S.of(context).promoCodeInvalid),
            duration: const Duration(seconds: 5),
            slideDismissDirection: DismissDirection.horizontal,
            context: context,
          );
          break;
        case CartStatus.error:
          showSimpleNotification(
            Text(S.of(context).errorGeneric),
            duration: const Duration(seconds: 5),
            slideDismissDirection: DismissDirection.horizontal,
            context: context,
          );
          break;
      }
    } finally {
      context.read(_proceedButtonStateProvider(actionLabel)).state =
          ButtonState.idle;
    }
  }

  Future<String?> showAddPromoDialog(
      BuildContext context, TextEditingController controller) {
    controller.clear();
    return showDialog<String>(
        context: context,
        builder: (context) {
          return AdaptiveAlertDialog(
            content: defaultTargetPlatform == TargetPlatform.iOS
                ? CupertinoTextFormFieldRow(
                    padding: const EdgeInsets.all(8.0),
                    placeholder: S.of(context).promoCodeLabel,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    style: Theme.of(context).textTheme.bodyText2,
                    controller: controller,
                    cursorColor: Theme.of(context).colorScheme.secondary,
                    maxLines: 1,
                  )
                : StyledFormField(
                    controller: controller,
                    validator: null,
                    labelText: S.of(context).promoCodeLabel,
                    onSaved: null,
                    keyboardType: TextInputType.text,
                    autoFocus: true,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 1,
                  ),
            title: Text(S.of(context).promoCodeLabel),
            actions: defaultTargetPlatform == TargetPlatform.iOS
                ? [
                    CupertinoDialogAction(
                      child: Text(S.of(context).cancelButton),
                      onPressed: () => Navigator.pop(context, null),
                    ),
                    CupertinoDialogAction(
                      onPressed: () => Navigator.pop(context, controller.text),
                      isDefaultAction: true,
                      child: Text(S.of(context).saveButton),
                    ),
                  ]
                : [
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, null),
                      child: Text(S.of(context).cancelButton),
                    ),
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, controller.text),
                      child: Text(
                        S.of(context).saveButton,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ],
          );
        });
  }
}
