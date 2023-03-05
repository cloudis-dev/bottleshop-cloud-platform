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
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/features/orders/data/models/order_model.dart';
import 'package:delivery/src/features/orders/presentation/widgets/orders_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const double _disabledOpacity = .3;

class OrderStepsWidget extends StatelessWidget {
  const OrderStepsWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            ...Iterable<int>.generate(order.orderType.orderStepsIds.length)
                .map(
                  (e) => [
                    _OrderStepRow(
                      orderStepId: order.orderType.orderStepsIds[e]!,
                      order: order,
                    ),
                    if (e < order.orderType.orderStepsIds.length - 1)
                      _OrderStepConnectorDivider(
                        enabled: e < order.statusStepsDates.length,
                      )
                  ],
                )
                .expand((element) => element)
                .cast<Widget>()
          ],
        ),
      );
}

class _OrderStepRow extends HookConsumerWidget {
  _OrderStepRow({
    Key? key,
    required this.order,
    required this.orderStepId,
  })  : isEnabled = orderStepId <= order.statusStepId,
        super(key: key);

  final OrderModel order;
  final int orderStepId;
  final bool isEnabled;

  bool isLastStep() {
    return order.orderType.orderStepsIds.last == orderStepId;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(currentLanguageProvider);
    return Row(
      children: [
        Icon(
          isLastStep() ? Icons.check_circle : Icons.circle,
          // OrdersView.orderStepsIcons[orderStepId],
          // color: isLast ? AppTheme.completedOrderColor : Colors.black,
          color: (isLastStep()
                  ? Colors.green
                  : Theme.of(context).colorScheme.secondary)
              .withOpacity(isEnabled ? 1 : _disabledOpacity),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  OrdersWidget.getOrderStepNames(context)[orderStepId],
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '-',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Expanded(
                  child: Text(
                    isEnabled
                        ? FormattingUtils.getDateTimeFormatter(currentLang)
                            .format(
                            order.statusStepsDates[order.orderType.orderStepsIds
                                .indexOf(orderStepId)],
                          )
                        : context.l10n.waiting,
                    style: Theme.of(context).textTheme.subtitle2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderStepConnectorDivider extends StatelessWidget {
  const _OrderStepConnectorDivider({
    Key? key,
    required this.enabled,
  }) : super(key: key);

  final bool enabled;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: SizedBox(
              height: 15,
              child: VerticalDivider(
                thickness: 2,
                color: enabled
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(_disabledOpacity),
              ),
            ),
          ),
        ],
      );
}
