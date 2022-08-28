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

import 'package:delivery/generated/l10n.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/features/account/presentation/widgets/account_card.dart';
import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/cart/data/models/cart_model.dart';
import 'package:delivery/src/features/checkout/data/models/payment_data.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/checkout_tile.dart';
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
    return S.of(context).reminderChooseDelivery;
  }
  if (reasons.contains(DeniedReason.email) ||
      reasons.contains(DeniedReason.name) ||
      reasons.contains(DeniedReason.phoneNumber)) {
    return S.of(context).pleaseFillOutYourEmailAndName;
  } else if (reasons.contains(DeniedReason.shippingAddress) ||
      reasons.contains(DeniedReason.billingAddress)) {
    return S.of(context).pleaseFillOutYourEmailNameBillingAndShippingAddress;
  } else if (reasons.contains(DeniedReason.shipToCity)) {
    return S.of(context).quickDeliveryIsPossibleOnlyInBratislava;
  } else if (reasons.contains(DeniedReason.quickDeliveryNotice)) {
    return S.of(context).reminderOpeningHours;
  }
  return reasons.toString();
}

class DeliveryOptionState extends StateNotifier<DeliveryOption>
    with DeliveryAvailableForUserCheck {
  DeliveryOptionState() : super(DeliveryOption.none);

  void selectDeliveryOption(DeliveryOption? newOption) {
    if (newOption != state) {
      state = newOption!;
    }
  }

  String? get label {
    return ChargeShipping.fromDeliveryOption(state).shipping;
  }

  bool get paymentRequired {
    return state != DeliveryOption.cashOnDelivery;
  }
}

final deliveryOptionsStateProvider =
    StateNotifierProvider.autoDispose<DeliveryOptionState, DeliveryOption>(
  (ref) => DeliveryOptionState(),
  name: 'deliveryOptionsStateProvider',
);

final _isLoadingProvider = StateProvider.autoDispose<bool>((_) => false);

class ShippingDetailsView extends HookWidget {
  final _logger = Logger((ShippingDetailsView).toString());

  final void Function(PaymentData paymentData) onNextPage;
  final void Function() onBackButton;

  ShippingDetailsView({
    Key? key,
    required this.onNextPage,
    required this.onBackButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDeliveryOption = useProvider(deliveryOptionsStateProvider);
    final remarksTextController = useTextEditingController();
    final scrollController = useScrollController();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        onUserDenied(context, [DeniedReason.noDeliverySelected]);
      });
      return () => {};
    }, const []);

    final isLoading = useProvider(_isLoadingProvider).state;

    return Loader(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).delivery,
          ),
          leading: BackButton(
            onPressed: () async {
              context.read(_isLoadingProvider).state = true;
              await context
                  .read(cloudFunctionsProvider)
                  .removeShippingFee()
                  .whenComplete(() {
                context.read(_isLoadingProvider).state = false;
              });
              onBackButton();
            },
          ),
        ),
        body: useProvider(currentUserAsStream).when(
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
                            itemCount: 3,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 5),
                            itemBuilder: (context, index) {
                              switch (index) {
                                case 0:
                                  return DeliveryOptionTile(user: user);
                                case 1:
                                  return const AccountCard(showBirthday: false);
                                default:
                                  return Card(
                                    color: Theme.of(context).primaryColor,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: ExpansionTile(
                                      initiallyExpanded: false,
                                      leading: const Icon(
                                        Icons.notes_outlined,
                                      ),
                                      title: Text(
                                        S.of(context).additionalRemarks,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      subtitle: Text(
                                        S.of(context).instructionsForDelivery,
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                      children: [
                                        ListTile(
                                          title: TextField(
                                            controller: remarksTextController,
                                            autofocus: true,
                                            maxLines: 5,
                                          ),
                                        )
                                      ],
                                    ),
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
                  actionLabel: context
                          .read(deliveryOptionsStateProvider.notifier)
                          .paymentRequired
                      ? S.of(context).proceedToCheckout
                      : S.of(context).confirmOrder,
                  actionCallback: context
                          .read(deliveryOptionsStateProvider.notifier)
                          .canProceed(user, selectedDeliveryOption)
                      ? () {
                          context.refresh(deliveryOptionsStateProvider);
                          final currentUser = context.read(currentUserProvider);
                          onNextPage(
                            PaymentData(
                              userId: currentUser?.uid,
                              customerId: currentUser?.stripeCustomerId,
                              email: currentUser?.email,
                              orderNote: remarksTextController.value.text,
                              deliveryType: context
                                  .read(deliveryOptionsStateProvider.notifier)
                                  .label,
                            ),
                          );
                        }
                      : null,
                ),
              ],
            );
          },
          loading: () => const Loader(),
          error: (err, stack) {
            _logger.severe('Failed to stream current user', err, stack);
            return Center(
              child: Text(S.of(context).error),
            );
          },
        ),
      ),
    );
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
}

class DeliveryOptionTile extends HookWidget {
  final UserModel? user;

  const DeliveryOptionTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderTypes = useProvider(
        commonDataRepositoryProvider.select((value) => value.orderTypes));
    final selectedDeliveryOption = useProvider(deliveryOptionsStateProvider);
    final currentLocale = useProvider(currentLocaleProvider);
    final items = <Widget>[
      Container(
        padding: const EdgeInsets.only(left: 68),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            S.of(context).payUpfront,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
            textAlign: TextAlign.start,
          ),
        ),
      ),
      Divider(
        height: 10,
        thickness: 2,
        indent: 68,
        endIndent: 980,
        color: Theme.of(context).colorScheme.secondary,
      ),
      ...orderTypes
          .map<Widget>(
            (orderType) => RadioListTile<DeliveryOption>(
              title: Text(orderType.getName(currentLocale)!,
                  style: Theme.of(context).textTheme.bodyText1),
              subtitle: Text(orderType.getDescription(currentLocale)!,
                  style: Theme.of(context).textTheme.caption),
              dense: true,
              activeColor: Theme.of(context).colorScheme.secondary,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              value: orderType.deliveryOption,
              groupValue: selectedDeliveryOption,
              onChanged: (value) {
                context
                    .read(deliveryOptionsStateProvider.notifier)
                    .selectDeliveryOption(value);
                context.read(cloudFunctionsProvider).setShippingFee(value);
                final deniedReasons = context
                    .read(deliveryOptionsStateProvider.notifier)
                    .validate(user, value);
                onUserDenied(context, deniedReasons);
              },
            ),
          )
          .toList(),
    ];
    items.insertAll(items.length - 1, <Widget>[
      Container(
        padding: const EdgeInsets.only(left: 65),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            S.of(context).payLater,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
            textAlign: TextAlign.start,
          ),
        ),
      ),
      Divider(
        height: 10,
        thickness: 2,
        indent: 65,
        endIndent: 980,
        color: Theme.of(context).colorScheme.secondary,
      ),
    ]);

    return Card(
      color: Theme.of(context).primaryColor,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.only(bottom: 8),
        initiallyExpanded: true,
        leading: const Icon(
          Icons.airport_shuttle,
        ),
        title: Text(
          S.of(context).deliveryOptions,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        subtitle: Text(
          S.of(context).selectDeliveryOption,
          style: Theme.of(context).textTheme.caption,
        ),
        children: items,
      ),
    );
  }
}
