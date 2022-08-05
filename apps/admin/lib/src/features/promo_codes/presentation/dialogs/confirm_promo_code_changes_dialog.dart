import 'package:bottleshop_admin/src/config/app_strings.dart';
import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/action_result.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/processing_alert_dialog.dart';
import 'package:bottleshop_admin/src/features/promo_codes/data/models/promo_code_model.dart';
import 'package:bottleshop_admin/src/features/promo_codes/data/repositories/promo_codes_repository.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/providers/providers.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PromoCodeEditingResult {
  PromoCodeEditingResult(this.result, this.message);

  final String message;
  final ActionResult result;
}

class ConfirmPromoCodeChangesDialog extends ProcessingAlertDialog {
  ConfirmPromoCodeChangesDialog({
    Key? key,
    required PromoCodeModel promoCode,
    required PromoCodeModel previousCode,
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
          onPositiveOption: (context) async =>
              _onPositiveOption(context, promoCode, previousCode),
          onNegativeOption: Navigator.pop,
        );

  static Future<void> _onPositiveOption(
    BuildContext context,
    PromoCodeModel promoCode,
    PromoCodeModel previousCode,
  ) async {
    if (context.read(isCreatingPromoCodeProvider)) {
      try {
        await context.read(promoCodesRepository).createPromoCode(promoCode);
        Navigator.pop(
          context,
          PromoCodeEditingResult(
            ActionResult.success,
            AppStrings.promoCodeCreatedMsg,
          ),
        );
      } on PromoCodeAlreadyExistsException catch (e) {
        Navigator.pop(
          context,
          PromoCodeEditingResult(
            ActionResult.failed,
            e.message,
          ),
        );
      } catch (err, stack) {
        FirebaseCrashlytics.instance.recordError(err, stack);

        Navigator.pop(
          context,
          PromoCodeEditingResult(
            ActionResult.failed,
            AppStrings.unknownErrorMsg,
          ),
        );
      }
    } else {
      try {
        await context.read(promoCodesRepository).updatePromoCode(
              promoCode,
              previousCode,
            );

        Navigator.pop(
          context,
          PromoCodeEditingResult(
            ActionResult.success,
            AppStrings.promoCodeEditedMsg,
          ),
        );
      } catch (err, stack) {
        FirebaseCrashlytics.instance.recordError(err, stack);

        Navigator.pop(
          context,
          PromoCodeEditingResult(
            ActionResult.failed,
            AppStrings.unknownErrorMsg,
          ),
        );
      }
    }
  }

  @override
  Widget content(BuildContext context) => Text(
        context.read(isCreatingPromoCodeProvider)
            ? 'Vytvoriť promo kód?'
            : 'Upraviť promo kód?',
        style: AppTheme.alertDialogContentTextStyle,
      );
}
