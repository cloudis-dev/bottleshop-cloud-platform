import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:bottleshop_admin/models/order_model.dart';
import 'package:bottleshop_admin/utils/formatting_util.dart';
import 'package:flutter/material.dart';

class TitleRow extends StatelessWidget {
  const TitleRow({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: 'ID: ',
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                  children: <TextSpan>[
                    TextSpan(
                      text: order.orderId.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Zaplatené: ',
                style: AppTheme.subtitle1TextStyle.copyWith(fontSize: 15),
                children: <TextSpan>[
                  TextSpan(
                    text: FormattingUtil.getPriceString(order.totalPaid),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
