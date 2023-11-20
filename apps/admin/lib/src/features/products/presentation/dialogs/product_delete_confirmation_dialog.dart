import 'package:bottleshop_admin/src/config/app_strings.dart';
import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/action_result.dart';
import 'package:bottleshop_admin/src/core/data/services/firebase_storage_service.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/processing_alert_dialog.dart';
import 'package:bottleshop_admin/src/features/products/data/models/product_model.dart';
import 'package:bottleshop_admin/src/features/products/data/services/services.dart';
import 'package:flutter/material.dart';

class ProductDeleteResult {
  ProductDeleteResult(this.result, this.message);

  final String message;
  final ActionResult result;
}

class ProductDeleteConfirmationDialog extends ProcessingAlertDialog {
  ProductDeleteConfirmationDialog({
    super.key,
    required ProductModel product,
  }) : super(
          actionButtonColor: Colors.red,
          negativeButtonOptionBuilder: (_) => Text('Nie',
              style: AppTheme.buttonTextStyle.copyWith(color: Colors.grey)),
          positiveButtonOptionBuilder: (_) => Text(
            'Áno',
            style: AppTheme.buttonTextStyle.copyWith(color: Colors.white),
          ),
          onPositiveOption: (context) => _onPositiveOption(context, product),
          onNegativeOption: Navigator.pop,
        );

  static Future<void> _onPositiveOption(
    BuildContext context,
    ProductModel product,
  ) async {
    try {
      await productsDbService.removeItem(product.uniqueId);

      if (product.hasImage) {
        await FirebaseStorageService.deleteImgAndThumbnail(product.uniqueId);
      }
      Navigator.pop(
        context,
        ProductDeleteResult(ActionResult.success, AppStrings.productDeletedMsg),
      );
    } catch (_) {
      Navigator.pop(
        context,
        ProductDeleteResult(ActionResult.failed, AppStrings.unknownErrorMsg),
      );
    }
  }

  @override
  Widget content(BuildContext context) => Text(
        'Naozaj chcete odstrániť tento produkt?',
        style: AppTheme.alertDialogContentTextStyle,
      );
}
