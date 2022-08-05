import 'package:bottleshop_admin/src/core/presentation/widgets/active_text_field.dart';
import 'package:bottleshop_admin/src/core/utils/math_util.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/models/promo_code_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PromoDiscountPercentField extends HookWidget {
  const PromoDiscountPercentField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textCtrl = useTextEditingController(
      text: useProvider(
        initialPromoCodeProvider
            .select((value) => value.state.discountValue.toString()),
      ),
    );

    return ActiveTextField(
      label: 'Percentuálna zľava',
      ctrl: textCtrl,
      keyboardType: TextInputType.number,
      suffix: '%',
      onSaved: (value) {
        value = value?.replaceAll(',', '.');
        var res = double.tryParse(value ?? '') ?? 0;
        res = double.tryParse(res.toStringAsFixed(2)) ?? 0;

        context.read(editedPromoCodeProvider).state =
            context.read(editedPromoCodeProvider).state.copyWith(
                  discountValue: res,
                  promoCodeType: PromoCodeType.percent,
                  minCartValue: 0,
                );
      },
      validator: (val) {
        final parsed = double.tryParse(val?.replaceAll(',', '.') ?? '');
        if (parsed == null) {
          return 'Musí byť číslo';
        }

        if (MathUtil.approximately(parsed, 0) || parsed < 0) {
          return 'Musí byť väčšie ako 0';
        }

        if (parsed > 100) {
          return 'Musí byť menšie ako 100';
        }
      },
    );
  }
}
