import 'package:bottleshop_admin/src/config/app_strings.dart';
import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/action_result.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/processing_alert_dialog.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:flutter/material.dart';

class ProductImageDeleteResult {
  ProductImageDeleteResult(this.result, this.message);

  final String message;
  final ActionResult result;
}

class ProductImageDeleteDialog extends ProcessingAlertDialog {
  ProductImageDeleteDialog({
    Key? key,
  }) : super(
          key: key,
          actionButtonColor: Colors.red,
          negativeButtonOptionBuilder: (_) => Text(
            'Nie',
            style: AppTheme.buttonTextStyle.copyWith(color: Colors.grey),
          ),
          positiveButtonOptionBuilder: (_) => Text(
            'Áno',
            style: AppTheme.buttonTextStyle.copyWith(color: Colors.white),
          ),
          onPositiveOption: _onPositiveOption,
          onNegativeOption: Navigator.pop,
        );

  static Future<void> _onPositiveOption(BuildContext context) async {
    try {
      DeleteImage(context);
      Navigator.pop(
        context,
        ProductImageDeleteResult(
          ActionResult.success,
          AppStrings.productImageRemovedMsg,
        ),
      );
    } catch (e) {
      Navigator.pop(
        context,
        ProductImageDeleteResult(
          ActionResult.failed,
          AppStrings.unknownErrorMsg,
        ),
      );
    }
  }

  @override
  Widget content(BuildContext context) => Text(
        'Odstrániť obrázok?',
        style: AppTheme.alertDialogContentTextStyle,
      );
}
