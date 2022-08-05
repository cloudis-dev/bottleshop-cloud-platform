import 'package:bottleshop_admin/src/config/app_strings.dart';
import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/price_row.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/processing_alert_dialog.dart';
import 'package:bottleshop_admin/src/core/result_message.dart';
import 'package:bottleshop_admin/src/core/utils/formatting_util.dart';
import 'package:bottleshop_admin/src/features/discount/presentation/widgets/product_discount_text_field.dart';
import 'package:bottleshop_admin/src/features/products/data/services.dart';
import 'package:bottleshop_admin/src/models/product_model.dart';
import 'package:bottleshop_admin/src/view_models/processing_alert_dialog_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final discountEditInitialProductProvider =
    StateProvider.autoDispose<ProductModel>((_) => ProductModel.empty());

final discountEditedProductProvider = StateProvider.autoDispose<ProductModel>(
    (ref) => ref.watch(discountEditInitialProductProvider).state);

final _isLoadedProvider = Provider.autoDispose<bool>(
  (ref) =>
      ref.watch(discountEditInitialProductProvider).state !=
      ProductModel.empty(),
);

final _discountEditFormKey =
    Provider.autoDispose<GlobalKey<FormState>>((_) => GlobalKey<FormState>());

final _isDiscountChanged = Provider.autoDispose<bool>(
  (ref) =>
      ref.watch(discountEditInitialProductProvider) !=
      ref.watch(discountEditedProductProvider),
);

class DiscountSetupDialog extends ProcessingAlertDialog {
  DiscountSetupDialog({
    Key? key,
    required this.product,
  }) : super(
          key: key,
          actionButtonColor: AppTheme.primaryColor,
          contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 24),
          negativeButtonOptionBuilder: (_) => Text('ZRUŠIŤ',
              style: AppTheme.buttonTextStyle.copyWith(color: Colors.grey)),
          positiveButtonOptionBuilder: (_) => Text(
            'POTVRDIŤ',
            style: AppTheme.buttonTextStyle.copyWith(color: Colors.white),
          ),
          onPositiveOption: _onPositiveOption,
          onNegativeOption: Navigator.pop,
          isPositiveButtonActive: false,
        );

  final ProductModel product;

  static Future _onPositiveOption(BuildContext context) async {
    try {
      if (context.read(_isDiscountChanged)) {
        final product = context.read(discountEditedProductProvider).state;
        await productsDbService.updateData(
          product.uniqueId,
          product.toFirebaseJson(),
        );

        Navigator.pop(
          context,
          ResultMessage(AppStrings.productDiscountSetupMsg),
        );
      }
    } catch (_) {
      Navigator.pop(
        context,
        ResultMessage(AppStrings.unknownErrorMsg),
      );
    }
  }

  @override
  Widget content(BuildContext context) {
    useEffect(() {
      Future.microtask(() =>
          context.read(discountEditInitialProductProvider).state = product);
    }, []);

    final formKey = useProvider(_discountEditFormKey);
    final initialProduct =
        useProvider(discountEditInitialProductProvider).state;
    final editedProduct = useProvider(discountEditedProductProvider).state;

    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 8),
          child: !useProvider(_isLoadedProvider)
              ? const Center(
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Text('Zľava',
                          style: AppTheme.alertDialogTitleTextStyle),
                    ),
                    Form(
                      key: formKey,
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: ProductDiscountTextField(),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),
                    PriceRow(
                      title: 'Pred zľavou bez DPH:',
                      priceString: FormattingUtil.getPriceString(
                        initialProduct.priceNoVat,
                      ),
                      textStyle: AppTheme.alertDialogContentTextStyle
                          .copyWith(fontSize: 12),
                    ),
                    PriceRow(
                      title: 'Pred zľavou s DPH:',
                      priceString: FormattingUtil.getPriceString(
                        initialProduct.priceWithVatWithoutDiscount,
                      ),
                      textStyle: AppTheme.alertDialogContentTextStyle
                          .copyWith(fontSize: 12),
                    ),
                    const Divider(),
                    PriceRow(
                      title: 'Cena po zľave:',
                      priceString: FormattingUtil.getPriceString(
                        editedProduct.finalPriceWithVat,
                      ),
                      textStyle: AppTheme.headline2TextStyle,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  @protected
  Widget positiveButton(
    BuildContext context,
    _,
    ProcessingAlertDialogViewModel model,
  ) {
    return super.positiveButton(
      context,
      useProvider(_isDiscountChanged) &&
          (useProvider(_discountEditFormKey).currentState?.validate() ?? false),
      model,
    );
  }
}
