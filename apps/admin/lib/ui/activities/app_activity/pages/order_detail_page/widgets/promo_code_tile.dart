import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:bottleshop_admin/models/order_model.dart';
import 'package:bottleshop_admin/models/promo_code_model.dart';
import 'package:bottleshop_admin/utils/formatting_util.dart';
import 'package:flutter/material.dart';

class PromoCodeTile extends StatelessWidget {
  final OrderModel order;

  const PromoCodeTile({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Promo kód',
        style: AppTheme.headline2TextStyle,
      ),
      subtitle: Text(
        order.promoCode!,
        style: AppTheme.headline3TextStyle,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (order.promoCodeType == PromoCodeType.percent)
            Text(
              '${order.promoCodeValue}%',
              style: AppTheme.headline2TextStyle,
            ),
          Text(
            FormattingUtil.getPriceString(-order.promoCodeDiscountValue),
            style: AppTheme.headline2TextStyle,
          ),
        ],
      ),
    );
  }
}
