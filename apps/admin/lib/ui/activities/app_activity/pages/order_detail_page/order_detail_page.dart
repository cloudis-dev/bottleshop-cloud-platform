import 'dart:async';

import 'package:bottleshop_admin/app_page.dart';
import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:bottleshop_admin/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/features/orders/data/services.dart';
import 'package:bottleshop_admin/models/order_model.dart';
import 'package:bottleshop_admin/models/order_type_model.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/pages/order_detail_page/order_detail_providers.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/pages/order_detail_page/widgets/cart_item_widget.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/pages/order_detail_page/widgets/order_detail_text_widget.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/pages/order_detail_page/widgets/order_steps_widget.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/pages/order_detail_page/widgets/promo_code_tile.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/pages/order_detail_page/widgets/title_row.dart';
import 'package:bottleshop_admin/ui/shared_widgets/chips/orders/order_chips_row.dart';
import 'package:bottleshop_admin/utils/formatting_util.dart';
import 'package:bottleshop_admin/utils/logical_utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderDetailPage extends AppPage {
  OrderDetailPage({
    OrderModel? order,
    String? orderUniqueId,
  })  : assert(LogicalUtils.xor(order != null, orderUniqueId != null)),
        super(
          'order/${order?.uniqueId ?? orderUniqueId}',
          (_) => _OrderDetailView(order?.uniqueId ?? orderUniqueId),
          pageArgs: order?.uniqueId ?? orderUniqueId,
        );

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
}

class _OrderDetailView extends HookWidget {
  const _OrderDetailView(this._orderUniqueId);
  final String? _orderUniqueId;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.microtask(
        () => context.read(orderDetailPageOrderStreamProvider.notifier).load(
              ordersDbService.streamSingle(_orderUniqueId),
            ),
      );
      return;
    }, []);

    final val = useProvider(orderDetailPageOrderStreamProvider);

    return ScaffoldMessenger(
      key: OrderDetailPage.scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detail objednávky'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                context.read(navigationProvider.notifier).popPage(),
          ),
        ),
        body: val.when(
          data: (order) => ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderChipsRow(order: order),
                    TitleRow(order: order),
                    OrderDetailTextWidget(
                      titleText: 'MENO ZÁKAZNÍKA',
                      valueText: order.customer.name,
                      bottomPadding: 0,
                    ),
                    OrderDetailTextWidget(
                      titleText: 'EMAIL',
                      valueText: order.customer.email,
                      hasCopyOption: true,
                      bottomPadding: 0,
                    ),
                    OrderDetailTextWidget(
                      titleText: 'KONTAKT',
                      valueText: order.customer.phoneNumber,
                      hasCopyOption: true,
                      bottomPadding: 0,
                    ),
                    if (order.hasNote)
                      OrderDetailTextWidget(
                        titleText: 'POZNÁMKA',
                        valueText: order.note,
                      ),
                    if (order.orderType.orderTypeCode !=
                        OrderTypeCode.pickUp) ...[
                      if (order.customer.shippingAddress != null) ...[
                        Text(
                          'Dodacie údaje',
                          style: AppTheme.headline3TextStyle,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Ink(
                          color: AppTheme.lightOrangeSolid,
                          child: Column(
                            children: [
                              OrderDetailTextWidget(
                                titleText: 'ADRESA ZÁKAZNÍKA',
                                valueText: order.customer.shippingAddress!
                                    .getAddressAsString(),
                                hasCopyOption: true,
                                bottomPadding: 0,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                      if (order.customer.billingAddress != null) ...[
                        Text(
                          'Platobné údaje',
                          style: AppTheme.headline3TextStyle,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        OrderDetailTextWidget(
                          titleText: 'ADRESA ZÁKAZNÍKA',
                          valueText: order.customer.billingAddress!
                              .getAddressAsString(),
                          hasCopyOption: false,
                        ),
                      ],
                    ],
                    OrderStepsWidget(order: order),
                    const Divider(),
                  ],
                ),
              ),
              if (order.orderType.hasShippingFee)
                ListTile(
                  title: Text(
                    'Poplatok za dopravu',
                    style: AppTheme.headline2TextStyle,
                  ),
                  trailing: Text(
                    FormattingUtil.getPriceString(
                      order.orderType.shippingFeeWithVat,
                    ),
                    style: AppTheme.headline2TextStyle,
                  ),
                ),
              if (order.hasPromoCode) PromoCodeTile(order: order),
              Column(
                children: [
                  ...Iterable<int>.generate(order.cartItems.length).map(
                    (e) => CartItemWidget(
                      cartItem: order.cartItems[e],
                      id: e,
                      totalCount: order.cartItems.length,
                    ),
                  ),
                ],
              ),
            ],
          ),
          loading: () => const Center(
            child: SizedBox(
              height: 100,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          error: (err, stack) {
            FirebaseCrashlytics.instance.recordError(err, stack);
            Text(
              'Niekde nastala chyba.',
              style: TextStyle(color: Colors.red),
            );
          },
        ),
      ),
    );
  }
}
