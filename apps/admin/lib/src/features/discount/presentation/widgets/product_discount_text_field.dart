import 'package:bottleshop_admin/src/core/presentation/widgets/active_text_field.dart';
import 'package:bottleshop_admin/src/core/utils/discount_util.dart';
import 'package:bottleshop_admin/src/core/utils/math_util.dart';
import 'package:bottleshop_admin/src/features/discount/presentation/dialogs/discount_setup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:optional/optional.dart';

class ProductDiscountTextField extends HookWidget {
  const ProductDiscountTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final discount =
        useProvider(discountEditInitialProductProvider).state.discount;
    final textCtrl = useTextEditingController(
      text: discount == null
          ? null
          : DiscountUtil.getPercentageFromDiscount(discount).toString(),
    );

    return ActiveTextField(
      label: 'Zľava',
      ctrl: textCtrl,
      keyboardType: TextInputType.number,
      suffix: '%',
      validator: (val) {
        val = (val?.isEmpty) ?? false ? '0' : null;
        final parsed = double.tryParse(val?.replaceAll(',', '.') ?? '0');
        if (parsed == null) {
          return 'Musí byť číslo';
        }
        return null;
      },
      onSaved: (value) {
        final res = double.tryParse(value?.replaceAll(',', '.') ?? '');
        context.read(discountEditedProductProvider).state =
            context.read(discountEditedProductProvider).state.copyWith(
                  discount: res == null || MathUtil.approximately(res, 0)
                      ? Optional.empty()
                      : Optional.of(res / 100),
                );
      },
    );
  }
}
