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

import 'package:delivery/src/features/orders/data/models/order_model.dart';
import 'package:delivery/src/features/orders/presentation/widgets/orders_widget.dart';
import 'package:flutter/material.dart';

class OrderStateChip extends StatelessWidget {
  const OrderStateChip({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final stepText =
        OrdersWidget.getOrderStepNames(context)[order.statusStepId];
    final textStyle = Theme.of(context).textTheme.subtitle2;

    return Chip(
      clipBehavior: Clip.antiAlias,
      avatar: order.isComplete
          ? Icon(
              Icons.check_circle,
              color: textStyle!.color,
            )
          : null,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: StadiumBorder(
          side: BorderSide(color: Theme.of(context).primaryColor)),
      label: Text(
        stepText,
        style: Theme.of(context).textTheme.overline,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
