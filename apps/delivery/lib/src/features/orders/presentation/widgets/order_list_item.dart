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
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/widgets/list_item_container_decoration.dart';
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/features/orders/data/models/order_model.dart';
import 'package:delivery/src/features/orders/presentation/widgets/order_state_chip.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderListItem extends HookConsumerWidget {
  final OrderModel order;

  const OrderListItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(currentLocaleProvider);
    return Material(
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.secondary,
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: ListItemContainerDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              OrderStateChip(order: order),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${context.l10n.order} #${order.orderId}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 6),
                        DefaultTextStyle(
                          style: Theme.of(context).textTheme.subtitle2!,
                          child: Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
                            columnWidths: const {
                              0: IntrinsicColumnWidth(),
                              1: FixedColumnWidth(12),
                              2: FlexColumnWidth(),
                            },
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              TableRow(children: [
                                Text('${context.l10n.orderType}:'),
                                const SizedBox(),
                                Text(
                                  order.orderType.getName(currentLocale)!,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ]),
                              TableRow(children: [
                                Text('${context.l10n.itemsCount}:'),
                                const SizedBox(),
                                Text(
                                  order.cartItems.map((e) => e.count).fold(0, (dynamic acc, e) => acc + e).toString(),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ]),
                              TableRow(
                                children: [
                                  Text('${context.l10n.created}:'),
                                  const SizedBox(),
                                  Text(
                                    FormattingUtils.getDateFormatter(currentLocale).format(order.createdAt),
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const SizedBox(),
                                  const SizedBox(),
                                  Text(
                                    FormattingUtils.getTimeFormatter(currentLocale).format(order.createdAt),
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(FormattingUtils.getPriceNumberString(order.totalPaid, withCurrency: true),
                          style: Theme.of(context).textTheme.headline5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
