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
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/features/account/presentation/widgets/account_card.dart';
import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/checkout/presentation/providers/providers.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/checkout_tile.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/delivery_option_tile.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';

enum DeniedReason {
  email,
  name,
  phoneNumber,
  shippingAddress,
  billingAddress,
  shipToCity,
  noDeliverySelected,
  quickDeliveryNotice,
}

mixin DeliveryAvailableForUserCheck {
  final _logger = Logger((DeliveryAvailableForUserCheck).toString());

  bool canProceed(UserModel? user, DeliveryOption deliveryOption) {
    if (user == null) {
      return false;
    }

    var valRes = validate(user, deliveryOption);
    if (valRes.isEmpty ||
        (valRes.length == 1 &&
            valRes.elementAt(0) == DeniedReason.quickDeliveryNotice)) {
      return true;
    }
    return false;
  }

  List<DeniedReason> validate(UserModel? user, DeliveryOption? deliveryOption) {
    if (user == null) {
      return [];
    }

    _logger.fine(
        'validating user: ${user.uid} option: ${deliveryOption.toString()}');
    var deniedReasons = <DeniedReason>[];
    switch (deliveryOption) {
      case DeliveryOption.pickUp:
        if (user.email == null || user.email!.isEmpty) {
          deniedReasons.add(DeniedReason.email);
        }
        if (user.name == null || user.name!.isEmpty) {
          deniedReasons.add(DeniedReason.name);
        }
        if (user.phoneNumber == null || user.phoneNumber!.isEmpty) {
          deniedReasons.add(DeniedReason.phoneNumber);
        }
        break;
      case DeliveryOption.homeDelivery:
      case DeliveryOption.cashOnDelivery:
        if (user.email == null || user.email!.isEmpty) {
          deniedReasons.add(DeniedReason.email);
        }
        if (user.name == null || user.name!.isEmpty) {
          deniedReasons.add(DeniedReason.name);
        }
        if (user.billingAddress == null) {
          deniedReasons.add(DeniedReason.billingAddress);
        }
        if (user.shippingAddress == null) {
          deniedReasons.add(DeniedReason.shippingAddress);
        }
        break;
      case DeliveryOption.quickDeliveryBa:
        if (user.email == null || user.email!.isEmpty) {
          deniedReasons.add(DeniedReason.email);
        }
        if (user.name == null || user.name!.isEmpty) {
          deniedReasons.add(DeniedReason.name);
        }
        if (user.billingAddress == null) {
          deniedReasons.add(DeniedReason.billingAddress);
        }
        if (user.shippingAddress == null) {
          deniedReasons.add(DeniedReason.shippingAddress);
        }
        if (user.shippingAddress?.city.toLowerCase().trim() != 'bratislava') {
          deniedReasons.add(DeniedReason.shipToCity);
        }
        deniedReasons.add(DeniedReason.quickDeliveryNotice);
        break;
      case DeliveryOption.closeAreasDeliveryBa:
        if (user.email == null || user.email!.isEmpty) {
          deniedReasons.add(DeniedReason.email);
        }
        if (user.name == null || user.name!.isEmpty) {
          deniedReasons.add(DeniedReason.name);
        }
        if (user.billingAddress == null) {
          deniedReasons.add(DeniedReason.billingAddress);
        }
        if (user.shippingAddress == null) {
          deniedReasons.add(DeniedReason.shippingAddress);
        }
        break;
      default:
        if (user.email == null || user.email!.isEmpty) {
          deniedReasons.add(DeniedReason.email);
        }
        if (user.name == null || user.name!.isEmpty) {
          deniedReasons.add(DeniedReason.name);
        }
        if (user.billingAddress == null) {
          deniedReasons.add(DeniedReason.billingAddress);
        }
        if (user.shippingAddress == null) {
          deniedReasons.add(DeniedReason.shippingAddress);
        }
        deniedReasons.add(DeniedReason.noDeliverySelected);
    }
    _logger.fine(
        'user can proceed: ${deniedReasons.isEmpty} reasons: $deniedReasons}');
    return deniedReasons;
  }
}

void onUserDenied(BuildContext context, List<DeniedReason> reasons) {
  if (reasons.isNotEmpty) {
    var message = buildMessage(context, reasons);
    showSimpleNotification(
      Text(message),
      position: NotificationPosition.top,
      duration: const Duration(seconds: 3),
      slideDismissDirection: DismissDirection.horizontal,
      context: context,
    );
  }
}

String buildMessage(BuildContext context, List<DeniedReason> reasons) {
  if (reasons.contains(DeniedReason.noDeliverySelected)) {
    return context.l10n.reminderChooseDelivery;
  }
  if (reasons.contains(DeniedReason.email) ||
      reasons.contains(DeniedReason.name) ||
      reasons.contains(DeniedReason.phoneNumber)) {
    return context.l10n.pleaseFillOutYourEmailAndName;
  } else if (reasons.contains(DeniedReason.shippingAddress) ||
      reasons.contains(DeniedReason.billingAddress)) {
    return context.l10n.pleaseFillOutYourEmailNameBillingAndShippingAddress;
  } else if (reasons.contains(DeniedReason.shipToCity)) {
    return context.l10n.quickDeliveryIsPossibleOnlyInBratislava;
  } else if (reasons.contains(DeniedReason.quickDeliveryNotice)) {
    return context.l10n.reminderOpeningHours;
  }
  return reasons.toString();
}

class ShippingDetailsView extends HookConsumerWidget {
  final _logger = Logger((ShippingDetailsView).toString());

  final Future<void> Function() onNextPage;
  final void Function() onBackButton;

  ShippingDetailsView({
    Key? key,
    required this.onNextPage,
    required this.onBackButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDeliveryOption = ref.watch(deliveryOptionsStateProvider);
    final scrollController = useScrollController();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        onUserDenied(context, [DeniedReason.noDeliverySelected]);
      });
      return () => {};
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.delivery,
        ),
        leading: BackButton(onPressed: onBackButton),
      ),
      body: ref.watch(currentUserAsStream).when(
            data: (user) {
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 120),
                    padding: const EdgeInsets.only(bottom: 30),
                    child: CupertinoScrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: 2,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 5),
                              itemBuilder: (context, index) {
                                switch (index) {
                                  case 0:
                                    return DeliveryOptionTile(user: user);
                                  default:
                                    return const AccountCard(
                                      showBirthday: false,
                                    );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CheckoutTile(
                    showShipping: true,
                    actionLabel: ref
                            .read(deliveryOptionsStateProvider.notifier)
                            .paymentRequired
                        ? context.l10n.proceedToCheckout
                        : context.l10n.confirmOrder,
                    actionCallback: selectedDeliveryOption != null &&
                            ref
                                .read(deliveryOptionsStateProvider.notifier)
                                .canProceed(user, selectedDeliveryOption)
                        ? onNextPage
                        : null,
                  ),
                ],
              );
            },
            loading: () => const Loader(),
            error: (err, stack) {
              _logger.severe('Failed to stream current user', err, stack);
              return Center(
                child: Text(context.l10n.error),
              );
            },
          ),
    );
  }
}
