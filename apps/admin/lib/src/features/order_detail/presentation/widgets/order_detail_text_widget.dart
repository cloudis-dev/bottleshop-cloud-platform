import 'package:bottleshop_admin/src/config/app_strings.dart';
import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/utils/snackbar_utils.dart';
import 'package:bottleshop_admin/src/features/order_detail/presentation/pages/order_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderDetailTextWidget extends StatelessWidget {
  const OrderDetailTextWidget({
    Key? key,
    required this.titleText,
    required String? valueText,
    this.hasCopyOption = false,
    this.bottomPadding = 16,
  })  : _valueText = valueText ?? '',
        super(key: key);

  final String titleText;
  final String _valueText;
  final bool hasCopyOption;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titleText, style: AppTheme.overlineTextStyle),
                  Text(_valueText, style: AppTheme.headline2TextStyle),
                  const Divider(
                    height: 8,
                  ),
                ],
              ),
            ),
            if (hasCopyOption)
              IconButton(
                icon: Icon(Icons.content_copy),
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: _valueText)).then(
                  (_) => SnackBarUtils.showSnackBar(
                    OrderDetailPage.scaffoldMessengerKey.currentState!,
                    SnackBarDuration.short,
                    AppStrings.copiedMsg,
                  ),
                ),
              )
          ],
        ),
      );
}
