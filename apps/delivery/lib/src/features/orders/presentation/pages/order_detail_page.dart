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
import 'package:delivery/src/core/presentation/other/list_item_container_decoration.dart';
import 'package:delivery/src/core/presentation/pages/page_404.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/empty_tab.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/core/utils/math_utils.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_popup_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/home_page_template.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/page_body_template.dart';
import 'package:delivery/src/features/orders/data/models/order_model.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:delivery/src/features/orders/presentation/providers/providers.dart';
import 'package:delivery/src/features/orders/presentation/widgets/order_cart_list_item.dart';
import 'package:delivery/src/features/orders/presentation/widgets/order_state_chip.dart';
import 'package:delivery/src/features/orders/presentation/widgets/order_steps_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:routeborn/routeborn.dart';

final _logger = Logger((OrderDetailPage).toString());

class OrderDetailPage extends RoutebornPage with UpdatablePageNameMixin {
  static const String pagePathBase = 'order';

  final String orderUniqueId;

  static Tuple2<RoutebornPage, List<String>> fromPathParams(
    List<String> remainingPathArguments,
  ) {
    if (remainingPathArguments.isNotEmpty) {
      return Tuple2(
        OrderDetailPage(orderUniqueId: remainingPathArguments.first),
        remainingPathArguments.skip(1).toList(),
      );
    }

    return Tuple2(Page404(), remainingPathArguments);
  }

  OrderDetailPage({required this.orderUniqueId}) : super(pagePathBase) {
    builder = (context) => _OrderDetailPageView(
          orderUniqueId: orderUniqueId,
          setPageNameCallback: (str) => setPageName(context, str),
        );
  }

  @override
  String getPagePath() => '$pagePathBase/$orderUniqueId';

  @override
  String getPagePathBase() => pagePathBase;
}

class _OrderDetailPageView extends HookConsumerWidget {
  final String orderUniqueId;
  final SetPageNameCallback setPageNameCallback;

  const _OrderDetailPageView({
    Key? key,
    required this.orderUniqueId,
    required this.setPageNameCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final scrollCtrl = useScrollController();

    return ref.watch(orderStreamProvider(orderUniqueId)).when(
          data: (order) {
            if (order == null) {
              return const _OrderErrorTab();
            } else {
              setPageNameCallback('${context.l10n.order} #${order.orderId}');

              if (shouldUseMobileLayout(context)) {
                return Scaffold(
                  key: scaffoldKey,
                  appBar: AppBar(
                    leading: BackButton(
                        onPressed: () =>
                            ref.read(navigationProvider).popPage(context)),
                    title: Text('${context.l10n.order} #${order.orderId}'),
                    actions: [AuthPopupButton(scaffoldKey: scaffoldKey)],
                  ),
                  body: _Body(
                    order: order,
                    scrollCtrl: scrollCtrl,
                  ),
                );
              } else {
                return HomePageTemplate(
                  scaffoldKey: scaffoldKey,
                  appBarActions: [AuthPopupButton(scaffoldKey: scaffoldKey)],
                  body: Scrollbar(
                    controller: scrollCtrl,
                    child: PageBodyTemplate(
                      child: _Body(
                        order: order,
                        scrollCtrl: scrollCtrl,
                      ),
                    ),
                  ),
                );
              }
            }
          },
          loading: () => const Loader(),
          error: (err, stack) {
            _logger.severe('Failed stream orders', err, stack);

            return const _OrderErrorTab();
          },
        );
  }
}

class _OrderErrorTab extends ConsumerWidget {
  const _OrderErrorTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EmptyTab(
      icon: Icons.error_outline,
      message: context.l10n.upsSomethingWentWrong,
      buttonMessage: context.l10n.backToOrders,
      onButtonPressed: () => ref.read(navigationProvider).popPage(context),
    );
  }
}

class _Body extends HookConsumerWidget {
  final OrderModel order;
  final ScrollController scrollCtrl;

  const _Body({
    Key? key,
    required this.order,
    required this.scrollCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(currentLocaleProvider);

    const horizontalContentPadding = 20.0;

    return ListView(
      controller: scrollCtrl,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: horizontalContentPadding,
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: OrderStateChip(order: order),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.details,
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: 8),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: FixedColumnWidth(16),
            2: FlexColumnWidth(),
          },
          textBaseline: TextBaseline.alphabetic,
          children: [
            TableRow(
              children: [
                Text(
                  '${context.l10n.totalPaid}:',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(),
                Text(
                  FormattingUtils.getPriceNumberString(order.totalPaid,
                      withCurrency: true),
                  style: Theme.of(context).textTheme.subtitle2,
                )
              ],
            ),
            getSizedTableRow(),
            TableRow(
              children: [
                Text(
                  '${context.l10n.orderType}:',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(),
                Text(
                  order.orderType.getName(currentLocale)!,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
            if (!MathUtils.approximately(
                order.orderType.shippingFeeNoVat, 0)) ...[
              getSizedTableRow(),
              TableRow(
                children: [
                  Text(
                    '${context.l10n.shippingFee}:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(),
                  Text(
                    FormattingUtils.getPriceNumberString(
                      order.orderType.feeWithVat,
                      withCurrency: true,
                    ),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(bottom: 8),
          initiallyExpanded: true,
          leading: const Icon(
            Icons.notes_outlined,
          ),
          title: Text(
            context.l10n.furtherDetails,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          children: [
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: FixedColumnWidth(16),
                2: FlexColumnWidth(),
              },
              textBaseline: TextBaseline.alphabetic,
              children: [
                if (order.orderType.deliveryOption !=
                    DeliveryOption.pickUp) ...[
                  TableRow(
                    children: [
                      Text(
                        '${context.l10n.shippingAddress}:',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (order.customer.shippingAddress
                                    ?.getAddressPerLines() ??
                                [])
                            .map<Widget>(
                              (e) => Text(
                                e,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  getSizedTableRow(),
                ],
                TableRow(
                  children: [
                    Text(
                      '${context.l10n.phoneNumber}:',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(),
                    Text(
                      order.customer.phoneNumber!,
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                  ],
                ),
                if (order.note?.isNotEmpty ?? false) ...[
                  getSizedTableRow(),
                  TableRow(
                    children: [
                      Text(
                        '${context.l10n.notes}:',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(),
                      Text(
                        order.note!,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        OrderStepsWidget(order: order),
        const SizedBox(height: 12),
        Text(
          context.l10n.orderedItems,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return IntrinsicHeight(
              child: OverflowBox(
                maxWidth: constraints.maxWidth + horizontalContentPadding * 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (order.hasPromoCode)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: ListItemContainerDecoration(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.promoCodeLabel,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  order.promoCode!,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ],
                            ),
                            Text(
                              FormattingUtils.getPriceNumberString(
                                -order.promoCodeValue!,
                                withCurrency: true,
                              ),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ),
                    ...order.cartItems.map<Widget>((e) => OrderCartListItem(e)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  TableRow getSizedTableRow() {
    return const TableRow(
      children: [
        SizedBox(height: 4),
        SizedBox(),
        SizedBox(),
      ],
    );
  }
}
