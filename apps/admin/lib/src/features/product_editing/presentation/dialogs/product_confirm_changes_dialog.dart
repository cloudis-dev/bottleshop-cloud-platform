import 'package:bottleshop_admin/src/config/app_strings.dart';
import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/action_result.dart';
import 'package:bottleshop_admin/src/core/data/services/firebase_storage_service.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/processing_alert_dialog.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/products/data/services/services.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:optional/optional.dart';

class ProductEditingResult {
  ProductEditingResult(this.result, this.message);

  final String message;
  final ActionResult result;
}

class ProductConfirmChangesDialog extends ProcessingAlertDialog {
  ProductConfirmChangesDialog({
    Key? key,
    required this.isCreatingNewProduct,
  }) : super(
          key: key,
          actionButtonColor: AppTheme.primaryColor,
          negativeButtonOptionBuilder: (_) => Text(
            'Nie',
            style: AppTheme.buttonTextStyle.copyWith(color: Colors.grey),
          ),
          positiveButtonOptionBuilder: (_) => Text(
            'Áno',
            style: AppTheme.buttonTextStyle.copyWith(color: Colors.white),
          ),
          onPositiveOption: (context) => _onPositiveOption(
            context,
            isCreatingNewProduct,
          ),
          onNegativeOption: Navigator.pop,
        );

  final bool isCreatingNewProduct;

  static Future<void> _onPositiveOption(
    BuildContext context,
    bool isCreatingNewProduct,
  ) async {
    var product = context.read(editedProductProvider).state;
    final img = context.read(productImgProvider);
    try {
      if (context.read(isImgChangedProvider).state) {
        if (img == null) {
          await FirebaseStorageService.deleteImgAndThumbnail(product.uniqueId);
          product = product.copyWith(
            imagePath: Optional.empty(),
            thumbnailPath: Optional.empty(),
          );
        } else {
          final uploadResult = await FirebaseStorageService.uploadImgData(
            img,
            product.uniqueId,
          );
          product = product.copyWith(
            imagePath: Optional.of(uploadResult.imagePath),
            thumbnailPath: Optional.of(uploadResult.thumbnailPath),
          );
        }
      }

      if (isCreatingNewProduct) {
        if (await productsDbService.exists(id: product.uniqueId)) {
          Navigator.pop(
            context,
            ProductEditingResult(
                ActionResult.failed, 'Produkt s daným CMAT už existuje.'),
          );
        } else {
          await productsDbService.create(
            product.toFirebaseJson(),
            id: product.uniqueId,
          );

          Navigator.pop(
            context,
            ProductEditingResult(
              ActionResult.success,
              AppStrings.productCreatedMsg,
            ),
          );
        }
      } else {
        await productsDbService.updateData(
            product.uniqueId, product.toFirebaseJson());

        Navigator.pop(
          context,
          ProductEditingResult(
            ActionResult.success,
            AppStrings.productUpdatedMsg,
          ),
        );
      }
    } catch (_) {
      Navigator.pop(
        context,
        ProductEditingResult(ActionResult.failed, AppStrings.unknownErrorMsg),
      );
    }
  }

  @override
  Widget content(BuildContext context) {
    // AlertDialog
    return Text(
      isCreatingNewProduct
          ? 'Vytvoriť produkt?'
          : 'Potvrdiť všetky zmeny v produkte?',
      style: AppTheme.alertDialogContentTextStyle,
    );
  }
}
